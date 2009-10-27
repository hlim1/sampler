open Cil


let enabled =
  Options.registerBoolean
    ~flag:"isolate-shared-accesses"
    ~desc:"rewrite each statement to access no more than one shared, mutable location"
    ~ident:"IsolateSharedAccesses"
    ~default:false


(* test whether an lvalue might access shared, mutable data *)
let isSharedAccess = function
  | Var { vtype = TFun _ }, _ ->
      (* functions are immutable by nature *)
      false
  | Var { vglob = false; vaddrof = false }, _ ->
      (* locals whose address is never taken are unshared *)
      false
  | Var { vglob = true; vattr = vattr }, _
    when hasAttribute "thread" vattr ->
      (* thread-local storage is unshared *)
      false
  | Var { vglob = true }, _
  | Var { vaddrof = true }, _
  | Mem _, _ as lval ->
      (* shared, but perhaps immutable: check for const *)
      not (hasAttribute "const" (typeAttrs (typeOfLval lval)))


(* count shared accesses in an AST tree fragment *)
class sharedAccessesFinder =
  object
    inherit nopCilVisitor

    (* shared accesses found so far *)
    val mutable found = []
    method found = found

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
  | _ :: _ :: _ ->
      ignore (bug "instr's accesses to multiple shared, mutable locations should have been isolated:@!  @[%a@]@!" d_instr instr);
      failwith "internal error"
