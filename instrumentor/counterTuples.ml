open Cil
open Pretty
open Printf
open SchemeName


class manager name file =
  object (self)
    val tuples = FindGlobal.find (name.prefix ^ "CounterTuples") file
    val mutable nextId = 0
    val siteInfos = new QueueClass.container

    method private bump = Threads.bump file

    method addSite func selector (description : doc) location =
      let counter = (Var tuples, Index (integer nextId, Index (selector, NoOffset))) in
      nextId <- nextId + 1;
      let result = mkStmtOneInstr (self#bump counter location) in
      Sites.registry#add func result;
      siteInfos#push (func, location, description, result);
      result

    method patch =
      mapGlobals file
	begin
	  function
	    | GVar ({vtype = TArray (elementType, _, attributes)} as varinfo, initinfo, location)
	      when varinfo == tuples
	      ->
		GVar ({varinfo with vtype = TArray (elementType,
						    Some (integer nextId),
						    attributes)},
		      initinfo, location)

	    | GFun ({svar = {vname = "samplerReporter"}; sbody = sbody}, _) as global
	      when nextId > 0 ->
		let schemeReporter = FindFunction.find (name.prefix ^ "Reporter") file in
		let call = Call (None, Lval (var schemeReporter), [], locUnknown) in
		sbody.bstmts <- mkStmtOneInstr call :: sbody.bstmts;
		global

	    | other ->
		other
	end

    method saveSiteInfo digest channel =
      fprintf channel "<sites unit=\"%s\" scheme=\"%s\">\n"
	(Digest.to_hex (Lazy.force digest)) name.flag;

      siteInfos#iter
	(fun (func, location, description, statement) ->
	  let description = Pretty.sprint max_int description in
	  fprintf channel "%s\t%d\t%s\t%d\t%s\n"
	    location.file location.line
	    func.svar.vname
	    statement.sid
	    description);

      output_string channel "</sites>\n"
  end
