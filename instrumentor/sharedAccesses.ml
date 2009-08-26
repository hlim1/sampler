open Cil


let enabled =
  Options.registerBoolean
    ~flag:"isolate-shared-accesses"
    ~desc:"rewrite each statement to access no more than one shared, mutable location"
    ~ident:"IsolateSharedAccesses"
    ~default:false


(* test whether a type is immutable *)
let isImmutable typ =
  match unrollType typ with
  | TFun _ ->
      true
  | other ->
      hasAttribute "const" (typeAttrs other)


(* test whether an lvalue might access shared, mutable data *)
let isSharedAccess (lhost, _ as lval) =
  if isImmutable (typeOfLval lval) then
    false
  else
    (* mutable storage, but is it shared? *)
    match lhost with
    | Var { vglob = false; vaddrof = false } ->
	(* locals whose address is never taken are unshared *)
	false
    | Var { vglob = true; vattr = vattr } ->
	(* global storage is shared, but thread-local storage is unshared *)
	not (hasAttribute "thread" vattr)
    | Var { vglob = false; vaddrof = vaddrof } ->
	(* local is shared iff its address is taken *)
	vaddrof
    | Mem _ ->
	(* pointer assumed to address shared storage *)
	true


(* count shared accesses in an AST tree fragment *)
class sharedAccessesFinder =
  object
    inherit nopCilVisitor

    (* shared accesses found so far *)
    val mutable found = []
    method found = found

    method vexpr expr =
      match expr with
      | AlignOfE _
      | SizeOfE _ ->
	  (* no actual evaluation takes place below this point *)
	  SkipChildren
      | _ ->
	  DoChildren

    (* each lvalue counts as 0 or 1 shared access *)
    method vlval lval =
      if isSharedAccess lval then
	found <- lval :: found;
      DoChildren
  end


(* find all shared, mutable accesses in an instruction *)
let find instr =
  let finder = new sharedAccessesFinder in
  ignore (visitCilInstr (finder :> cilVisitor) instr);
  finder#found


(* rewrite function body so that no statement accesses >1 shared, mutable location *)
class isolator fundec =
  object (self)
    inherit nopCilVisitor

    (* enqueue evaluation of expression into new tempvar *)
    (* return replacement expression that just uses that tempvar *)
    method private createTemporaryFor expr =
      let description = dd_exp () expr in
      let typ = typeOf expr in
      let tempVar = makeTempVar fundec ~name:"cbi_shared_access" ~descr:description typ in
      var tempVar

    (* enqueue evaluation of expression into new tempvar *)
    (* return replacement expression that just uses that tempvar *)
    method private prefetchIntoTemporary expr =
      let tempVar = self#createTemporaryFor expr in
      let evalAndSave = Set (tempVar, expr, !currentLoc) in
      self#queueInstr [evalAndSave];
      Lval tempVar

    (* rewrite original call to store result in new tempvar *)
    (* then assign from tempvar into original result location *)
    method private postfetchFromTemporary = function
      | [Call (Some lval, callee, actuals, location)] ->
	  let tempVar = self#createTemporaryFor (Lval lval) in
	  [Call (Some tempVar, callee, actuals, location);
	   Set (lval, Lval tempVar, !currentLoc)]
      | _ ->
	  ignore (bug "call instruction turned into instruction(s) of some other kind");
	  failwith "internal error"

    (* rewrite bottom-up to remove shared, mutable accesses *)
    method vexpr = function
      | Lval lval as expr when isSharedAccess lval ->
	  ChangeDoChildrenPost (expr, self#prefetchIntoTemporary)
      | AlignOfE _
      | SizeOfE _ ->
	  (* no actual evaluation takes place below this point *)
	  SkipChildren
      | _ ->
	  DoChildren

    (* rewrite if more than one shared, mutable access *)
    (* assignment like "local = global;" remains unchanged *)
    method vinst = function
      | Set _ as instr ->
	  begin
	    match find instr with
	    | []
	    | [_] ->
		SkipChildren
	    | _ :: _ :: _ ->
		DoChildren
	  end
      | Call (Some result, _, _, _) as instr
	when isSharedAccess result ->
	  ChangeDoChildrenPost ([instr], self#postfetchFromTemporary)
      | Call _
      | Asm _ ->
	  DoChildren
  end



(** if enabled, rewrite all function bodies so that each Set
   instruction accesses at most one shared, mutable location, and no
   other statements access any shared, mutable locations at all *)
let isolate file =
  if !enabled then
    Scanners.iterFuncs file
      (fun fundec ->
	if FunctionFilter.filter#included fundec.svar.vname then
	  let isolator = new isolator fundec in
	  ignore (visitCilBlock isolator fundec.sbody))


(** return the single shared, mutable location accessed by this instruction, if any *)
let isolated instr =
  match find instr with
  | [] -> None
  | [singleton] -> Some singleton
  | (_ :: _ :: _) as several ->
      ignore
	(bug
	   "instruction's accesses to multiple shared, mutable locations should have been isolated:@!@!  instruction:@!    @[%a@]@!@!  %d accesses:@!    %a@!"
	   dn_instr instr
	   (List.length several)
	   (Pretty.d_list "\n    " dn_lval) several);
      failwith "internal error"
