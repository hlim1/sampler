open Cil
open Pretty


class visitor logger = object (self)
  inherit FunctionBodyVisitor.visitor as super

  method vstmt _ = DoChildren

  method vinst instr =
    let dissection = Collect.collect instr in
    let formats, arguments = List.split dissection in
    let format = ("%s:%u:\n\t" ^ String.concat "\n\t" formats ^ "\n") in
    let where = Where.locationOf instr in
    let call = 
      Call (None, logger,
	    mkString format
	    :: mkString where.file
	    :: kinteger IUInt where.line
	    :: arguments,
	    where)
    in
    super#queueInstr [call];
    SkipChildren
end
