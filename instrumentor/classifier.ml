open Cil


class visitor initial =
  object (self)
    inherit FunctionBodyVisitor.visitor

    val mutable calls = []

    method calls = calls

    method sites : stmt list = []

    val mutable globals : global list = [initial]

    method globals = globals
	
    method private addGlobal global =
      globals <- global :: globals

    method private prepatchCall stmt =
      let info = Calls.prepatch stmt in
      calls <- info :: calls;
      info

    method vstmt stmt =
      match stmt.skind with
      | Instr [Call _] ->
	  ignore (self#prepatchCall stmt);
	  SkipChildren
      | _ ->
	  DoChildren
  end
