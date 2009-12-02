open Cil
open Pretty
open Printf
open SchemeName


class manager name file =
  let counters = FindGlobal.find ("cbi_" ^ name.prefix ^ "Counters") file in

  object (self)
    val mutable nextId : int = 0
    val siteInfos = new QueueClass.container
    val stamper = Timestamps.set file

    method private bump = Threads.bump file

    method addSiteExpr siteInfo selector =
      self#addSiteOffset siteInfo (Index (selector, NoOffset))

   (*cci : add expression, but don't add it to the sites*)
   method addExpr selector = 
     self#addOffset (Index (selector, NoOffset))

   (*cci : add expression, but don't add it to the sites*)
   method addExpr2 selector0 selector1 = 
     self#addOffset2 (Index (selector0, NoOffset)) (Index (selector1, NoOffset))


    (* you are given the siteid here *)       
    method addExprId selector id =
      self#addOffsetId (Index (selector, NoOffset)) id

   (*cci-cmpwap*)
   (* siteInfo: site information *)
   (* set of statements which are to be sampled*)

    method addSiteStmts siteInfo statements =
      let func = siteInfo#fundec in
      let implementation = siteInfo#implementation in
      implementation.skind <- Block (mkBlock (statements));
      Sites.registry#add func (Site.build implementation);
      siteInfos#push siteInfo;
      siteInfos#push siteInfo;
      implementation

   (*cci*)
   (* siteInfo: site information *)
   (* set of instructions which are to be sampled*)

    method addSiteInstrs siteInfo instructions =
      let func = siteInfo#fundec in
      let implementation = siteInfo#implementation in
      implementation.skind <- IsolateInstructions.isolate instructions;
      Sites.registry#add func (Site.build implementation);
      siteInfos#push siteInfo;
      implementation

    (* cci: increment the count, but don't add it to the sites*)
    (* this means it won't be sampled*)
    method addOffset selector =
      let thisId = nextId in
      let site = (Var counters, Index (integer thisId, NoOffset)) in
      let counter = addOffsetLval selector site in
      let bump =  (self#bump counter locUnknown) in
      nextId <- nextId+1;
      bump, nextId

    method addSiteOffset siteInfo selector =
      let thisId = nextId in
      let site = (Var counters, Index (integer thisId, NoOffset)) in
      let func = siteInfo#fundec in
      let location = siteInfo#inspiration in
      let stamp = stamper name thisId location in
      let counter = addOffsetLval selector site in
      let bump = self#bump counter location in
      let implementation = siteInfo#implementation in
      let instructions = bump :: stamp in
      implementation.skind <- IsolateInstructions.isolate instructions;
      Sites.registry#add func (Site.build implementation);
      siteInfos#push siteInfo;
      nextId <- nextId + 1;
      implementation, thisId


    (* cci: increment the count, but don't add it to the sites*)
    (* this means it won't be sampled*)
    method addOffset2 selector0 selector1 =
      let thisId = nextId in
      let site = (Var counters, Index (integer thisId, NoOffset)) in
      let counter = addOffsetLval selector0 site in
      let bump0 =  (self#bump counter locUnknown) in
      nextId <- nextId+1;
      let thisId = nextId in
      let site = (Var counters, Index (integer thisId, NoOffset)) in
      let counter = addOffsetLval selector1 site in
      let bump1 =  (self#bump counter locUnknown) in
      nextId <- nextId+1;
      [bump0; bump1], nextId


    (* cci: increment the count, but don't add it to the sites*)
    (* this means it won't be sampled*)
    (* you are given the siteid here *)
    method addOffsetId selector id =
      let thisId = id in
      let site = (Var counters, Index (integer thisId, NoOffset)) in
      let counter = addOffsetLval selector site in
      let bump =  (self#bump counter locUnknown) in
      bump, nextId



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

	    | GFun ({svar = {vname = "cbi_reporter"}; sbody = sbody}, _) as global
	      when nextId > 0 ->
		let schemeReporter = FindFunction.find ("cbi_" ^ name.prefix ^ "Reporter") file in
		let call = Call (None, Lval (var schemeReporter), [], locUnknown) in
		sbody.bstmts <- mkStmtOneInstr call :: sbody.bstmts;
		global

	    | other ->
		other
	end

    method saveSiteInfo digest channel =
      SiteInfo.print channel digest name siteInfos
  end
