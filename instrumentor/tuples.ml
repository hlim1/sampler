open Cil
open SiteInfo


type siteId = int


class virtual builder prefix file =
  object (self)
    val mutable nextId = 0
    val sites = new SiteInfoQueue.container
    val counterTuples = FindGlobal.find (prefix ^ "CounterTuples") file
    val compilationUnit = FindGlobal.find (prefix ^ "CompilationUnit") file
    val siteInfo = FindGlobal.find (prefix ^ "SiteInfo") file


    method private addSiteInfo info =
      sites#push info;
      let slice = nextId in
      nextId <- nextId + 1;
      slice


    method finalize digest =
      let signature = Lazy.force digest in
      let siteCount = integer nextId in

      let fixer = function
	| GVar ({vtype = TArray (elementType, _, attributes)} as varinfo, initinfo, location)
	  when varinfo == counterTuples
	  ->
	    GVar ({varinfo with vtype = TArray (elementType, Some siteCount, attributes)},
		  initinfo, location)

	| GVar ({vtype = TComp (compinfo, _)} as varinfo, initinfo, _) as global
	  when varinfo == compilationUnit;
	  ->
	    let noOffset field = Field (field, NoOffset) in
	    let getOffset name = noOffset (getCompField compinfo name) in
	    let singleInit (name, expr) = getOffset name, SingleInit expr in
	    let inits = List.map singleInit [ "prev", zero;
					      "next", zero;
					      "signature", mkString signature;
					      "count", siteCount;
					      "tuples", mkAddrOrStartOf (var counterTuples) ]
	    in
	    initinfo.init <- Some (CompoundInit (varinfo.vtype, inits));
	    global

	| GVar ({vtype = TArray (elementType, None, attributes)} as varinfo, _, location)
	  when varinfo == siteInfo
	  ->
	    let init = sites#serialize signature in
	    let length = Some (integer (String.length init)) in
	    GVar ({varinfo with vtype = TArray (elementType, length, attributes) },
		  { init = Some (SingleInit (mkString init)) },
		  location)

	| other
	  ->
	    other

      in
      mapGlobals file fixer
  end
