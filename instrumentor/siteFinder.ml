open Cil


let fileFilter = new Clude.filter
    ~flag:"file"
    ~desc:"<file-name> instrument this file"
    ~ident:"FilterFile"


(**********************************************************************)


class visitor =
  object (self)
    inherit FunctionBodyVisitor.visitor

    method private includedStatement stmt =
      fileFilter#included (get_stmtLoc stmt.skind).file

    method private includedFunction func =
      FunctionFilter.filter#included func.svar.vname

    method vfunc func =
      if self#includedFunction func then
	DoChildren
      else
	SkipChildren
  end
