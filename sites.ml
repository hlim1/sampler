open Cil


class map = [instr] StmtMap.container


class virtual visitor =
  let sites = new map in
  
  object (self)
    inherit FunctionBodyVisitor.visitor
	
    method result = sites

    method virtual consider : stmtkind -> instr option
	
    method vstmt statement =
      begin
	match self#consider statement.skind with
	| Some instrumentation ->
	    sites#add statement instrumentation
	| None ->
	    ()
      end;

      DoChildren
  end
