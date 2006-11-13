open Cil


let fileFilter = new Clude.filter
    ~flag:"file"
    ~desc:"<file-name> instrument this file"
    ~ident:"FilterFile"


(**********************************************************************)


class visitor func =
  object (self)
    inherit FunctionBodyVisitor.visitor

    val mutable sites = []
    method sites : stmt list = sites

    method private includedStatement stmt =
      fileFilter#included (get_stmtLoc stmt.skind).file

    val includedFunction = FunctionFilter.filter#included func.svar.vname

    method private shouldVisit = includedFunction

    method private normalize =
      RemoveLoops.visit func;
      IsolateInstructions.visit func

    method vfunc _ =
      if self#shouldVisit then
	begin
	  self#normalize;
	  DoChildren
	end
      else
	SkipChildren
  end
