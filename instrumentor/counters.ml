open Cil
open Pretty
open Printf
open SchemeName


class manager name file =
  let counters = FindGlobal.find (name.prefix ^ "Counters") file in

  object (self)
    val mutable nextId = 0
    val siteInfos = new QueueClass.container
    val stamper = Timestamps.set file

    method private bump = Threads.bump file

    method addSite (siteInfo : SiteInfo.c) selector =
      let site = (Var counters, Index (integer nextId, NoOffset)) in
      let func = siteInfo#fundec in
      let location = siteInfo#inspiration in
      let stamp = stamper name nextId location in
      let counter = addOffsetLval selector site in
      let bump = self#bump counter location in
      let implementation = siteInfo#implementation in
      implementation.skind <- IsolateInstructions.isolate (bump :: stamp);
      Sites.registry#add func (Site.build implementation);
      siteInfos#push siteInfo;
      nextId <- nextId + 1;
      implementation

    method patch =
      mapGlobals file
	begin
	  function
	    | GVar ({vtype = TArray (elementType, _, attributes)} as varinfo, initinfo, location)
	      when varinfo == counters
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
	(fun siteInfo ->
	  Pretty.fprint channel max_int
	    ((seq (chr '\t') (fun doc -> doc) siteInfo#print)
	       ++ line));

      output_string channel "</sites>\n"
  end
