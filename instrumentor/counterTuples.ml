open Cil
open Pretty
open SchemeName


class type manager =
  object
    method private bump : lval -> location -> instr
    method addSite : fundec -> exp -> doc -> location -> stmt
    method finalize : Digest.t Lazy.t -> unit
  end


class virtual basis name file =
  object (self)
    val tuples = FindGlobal.find (name.prefix ^ "CounterTuples") file
    val mutable nextId = 0
    val siteInfos = new QueueClass.container

    method private virtual bump : lval -> location -> instr

    method addSite func selector description location =
      let counter = (Var tuples, Index (integer nextId, Index (selector, NoOffset))) in
      nextId <- nextId + 1;
      let result = mkStmtOneInstr (self#bump counter location) in
      Sites.registry#add func result;
      siteInfos#push (func, location, description, result);
      result

    method finalize digest =
      mapGlobals file
	begin
	  function
	    | GVar ({vtype = TArray (elementType, _, attributes)} as varinfo, initinfo, location)
	      when varinfo == tuples
	      ->
		GVar ({varinfo with vtype = TArray (elementType, Some (integer nextId), attributes)},
		      initinfo, location)

	    | GVar ({vname = vname}, initinfo, _) as global
	      when vname = name.prefix ^ "SiteInfo"
	      ->
		let buffer = new BufferClass.c 33 in
		buffer#addString
		  (sprint max_int
		     (seq nil text
			["<sites unit=\"";
			 Digest.to_hex (Lazy.force digest);
			 "\" scheme=\""; name.flag; "\">\n"]));

		let serializer (func, location, description, statement) =
		  let fields = [text location.file;
				num location.line;
				text func.svar.vname;
				num statement.sid;
				description]
		  in
		  let row = seq (chr '\t') (fun doc -> doc) fields in
		  let text = sprint max_int (row ++ chr '\n') in
		  buffer#addString text
		in
		siteInfos#iter serializer;

		initinfo.init <- Some (SingleInit (mkString buffer#contents));
		global

	    | GFun ({svar = {vname = "samplerReporter"}; sbody = sbody}, _) as global
	      when nextId > 0 ->
		let schemeReporter = FindFunction.find (name.prefix ^ "Reporter") file in
		let call = Call (None, Lval (var schemeReporter), [], locUnknown) in
		sbody.bstmts <- mkStmtOneInstr call :: sbody.bstmts;
		global

	    | other ->
		other
	end
  end


class nonThreaded name file =
  object
    inherit basis name file

    method private bump lval location =
      Set (lval, increm (Lval lval) 1, location)
  end


class threaded name file =
  object
    inherit basis name file

    val helper = Lval (var (FindFunction.find "atomicIncrementCounter" file))

    method private bump lval location =
      Call (None, helper, [mkAddrOrStartOf lval], location)
  end


let build name file =
  let factory =
    if !Threads.threads then
      new threaded
    else
      new nonThreaded
  in
  factory name file
