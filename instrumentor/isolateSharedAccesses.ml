open Cil


(* test whether an lvalue might access shared, mutable data *)
let isSharedAccess = function
  | Var { vtype = TFun _ }, _
  | Var { vglob = false; vaddrof = false }, _ ->
      (* definitely immutable or unshared *)
      false
  | Var { vaddrof = true }, _
  | Var { vglob = true }, _
  | Mem _, _ as lval ->
      (* shared, but perhaps immutable: check for const *)
      not (hasAttribute "const" (typeAttrs (typeOfLval lval)))


(* count shared accesses in an AST tree fragment *)
class countSharedAccessesVisitor =
  object
    inherit nopCilVisitor

    (* the final count, available after visit pass *)
    val mutable count = 0
    method count = count

    (* each lvalue counts as 0 or 1 shared access *)
    method vlval lval =
      if isSharedAccess lval then
	count <- count + 1;
      DoChildren
  end


(* return count of shared, mutable accesses in an instruction *)
(* will rewrite instruction if this returns >1 *)
let sharedAccessCount instr =
  let visitor = new countSharedAccessesVisitor in
  ignore (visitCilInstr (visitor :> cilVisitor) instr);
  visitor#count


(* rewrite function body so that no statement accesses >1 shared, mutable location *)
class visitor fundec =
  object (self)
    inherit nopCilVisitor

    (* enqueue evaluation of expression into new tempvar *)
    (* return replacement expression that just uses that tempvar *)
    method private prefetchIntoTemporary expr =
      let description = d_exp () expr in
      let typ = typeOf expr in
      let tempVar = makeTempVar fundec ~descr:description typ in
      let evalAndSave = Set (var tempVar, expr, !currentLoc) in
      self#queueInstr [evalAndSave];
      Lval (var tempVar)

    (* rewrite bottom-up to remove shared, mutable accesses *)
    method vexpr = function
      | Lval lval as expr when isSharedAccess lval ->
	  ChangeDoChildrenPost (expr, self#prefetchIntoTemporary)
      | _ ->
	  DoChildren

    (* rewrite if more than one shared, mutable access *)
    (* assignment like "local = global;" remains unchanged *)
    method vinst instr =
      if sharedAccessCount instr > 1 then
	DoChildren
      else
	SkipChildren
  end


(* rewrite all function bodies so that no single statement
   accesses more than one shared, mutable location *)
let visit file =
  Scanners.iterFuncs file
    (fun fundec ->
      let visitor = new visitor fundec in
      ignore (visitCilBlock visitor fundec.sbody))
