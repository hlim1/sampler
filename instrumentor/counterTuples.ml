open Cil


class type manager =
  object
    method private bump : lval -> location -> instr
    method addSite : fundec -> exp -> Pretty.doc -> location -> stmt
    method finalize : Digest.t Lazy.t -> unit
  end


class virtual basis prefix file =
  object (self)
    val tuples = FindGlobal.find (prefix ^ "CounterTuples") file
    val mutable nextId = 0

    method private virtual bump : lval -> location -> instr

    method addSite func selector (description : Pretty.doc) (location : location) =
      let counter = (Var tuples, Index (integer nextId, Index (selector, NoOffset))) in
      nextId <- nextId + 1;
      let result = mkStmtOneInstr (self#bump counter location) in
      Sites.registry#add func result;
      result

    method finalize (_ : Digest.t Lazy.t) =
      mapGlobals file
	begin
	  function
	    | GVar ({vtype = TArray (elementType, _, attributes)} as varinfo, initinfo, location)
	      when varinfo == tuples
	      ->
		GVar ({varinfo with vtype = TArray (elementType, Some (integer nextId), attributes)},
		      initinfo, location)

	    | GFun ({svar = {vname = "samplerReporter"}; sbody = sbody}, _) as global ->
		let schemeReporter = FindFunction.find (prefix ^ "Reporter") file in
		let call = Call (None, Lval (var schemeReporter), [], locUnknown) in
		sbody.bstmts <- mkStmtOneInstr call :: sbody.bstmts;
		global

	    | other ->
		other
	end
  end


class nonThreaded prefix file =
  object
    inherit basis prefix file

    method private bump lval location =
      Set (lval, increm (Lval lval) 1, location)
  end


class threaded prefix file =
  object
    inherit basis prefix file

    val helper = Lval (var (FindFunction.find "atomicIncrementCounter" file))

    method private bump lval location =
      Call (None, helper, [mkAddrOrStartOf lval], location)
  end


let build prefix file =
  let factory =
    if !Threads.threads then
      new threaded
    else
      new nonThreaded
  in
  factory prefix file
