open Cil


class visitor initial =
  object (self)
    inherit FunctionBodyVisitor.visitor

    val mutable calls = []
    method calls = calls

    method sites : stmt list = []

    val globals =
      let container = new GlobalQueue.container in
      container#add initial;
      container

    method globals = globals

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
