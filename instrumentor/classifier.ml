open Cil


let fileFilter = ref []


let _ =
  Clude.register
    ~flag:"file"
    ~desc:"<file-name> instrument this file"
    ~ident:"FilterFile"
    fileFilter


let funcFilter = ref []


let _ =
  Clude.register
    ~flag:"function"
    ~desc:"<function> instrument this function"
    ~ident:"FilterFunction"
    funcFilter


(**********************************************************************)


class visitor =
  object (self)
    inherit FunctionBodyVisitor.visitor

    val mutable calls = []
    method calls = calls

    method sites : stmt list = []

    method private prepatchCall stmt =
      let info = Calls.prepatch stmt in
      calls <- info :: calls;
      info

    method private includedFunction func =
      Clude.selected !funcFilter func.svar.vname

    method vfunc func =
      if self#includedFunction func then
	DoChildren
      else
	SkipChildren

    method private includedStatement stmt =
      Clude.selected !fileFilter (get_stmtLoc stmt.skind).file

    method vstmt stmt =
      match stmt.skind with
      | Instr [Call _] ->
	  ignore (self#prepatchCall stmt);
	  SkipChildren
      | _ ->
	  DoChildren
  end
