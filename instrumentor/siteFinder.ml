open Cil


class visitor =
  object (self)
    inherit FunctionBodyVisitor.visitor

    method private includedFile =
      FileFilter.filter#included

    method private includedStatement stmt =
      self#includedFile (get_stmtLoc stmt.skind).file

    method private includedFunction func =
      FunctionFilter.filter#included func.svar.vname

    method vfunc func =
      if self#includedFunction func then
	DoChildren
      else
	SkipChildren
  end
