open Cil


type instrumentation = instr list

class map = [instrumentation] StmtMap.container


class virtual visitor =
  let sites = new map in
  
  object (self)
    inherit FunctionBodyVisitor.visitor
	
    method result = sites

    method virtual consider : stmtkind -> instrumentation
	
    method vstmt statement =
      begin
	let instrumentation = self#consider statement.skind in
	if instrumentation != [] then
	  sites#add statement instrumentation
      end;

      DoChildren
  end
