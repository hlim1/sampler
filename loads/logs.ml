open Cil
open OutputSet
open Pretty


class visitor logger =

  let insert self visit root location =
    let dissection = Collect.collect visit root in
    let formats, arguments = List.split (OutputSet.elements dissection) in
    let format = ("%s:%u:\n" ^ String.concat "" formats) in
    let call = 
      Call (None, logger,
	    mkString format
	    :: mkString location.file
	    :: kinteger IUInt location.line
	    :: arguments,
	    location)
    in
    self#queueInstr [call]
  in
  
  object (self)

    inherit FunctionBodyVisitor.visitor

    method vstmt stmt =
      begin
	match stmt.skind with
	(* Switch should already have been removed by Cil.prepareCFG *)
	| Return (Some expression, location)
	| If (expression, _, _, location) ->
	    insert self visitCilExpr expression location
	|	_ -> ()
      end;
      DoChildren

    method vinst instr =
      let dissection = Collect.collect in
      insert self visitCilInstr instr (Where.locationOf instr);
      SkipChildren
  end
