open Cil
open SiteInfo


type slice = lval


class virtual builder file =
  object (self)
    val mutable nextId = 0
    val sites = new SiteInfoQueue.container
    val counterTuples = FindGlobal.find "counterTuples" file


    method private addSiteInfo info =
      sites#add info;
      let slice = (Var counterTuples, Index (integer nextId, NoOffset)) in
      nextId <- nextId + 1;
      slice


    method finalize =
      let signature = Digest.file file.fileName in
      let siteCount = integer nextId in

      let fixer = function
	| GVar ({vname = "counterTuples";
		 vtype = TArray (elementType, _, attributes)}
		  as varinfo,
		initinfo, location)
	  ->
	    GVar ({varinfo with vtype = TArray (elementType, Some siteCount, attributes)},
		  initinfo, location)

	| GVar ({vname = "compilationUnit";
		 vtype = TComp (compinfo, _)}
		  as varinfo,
		initinfo, _) as global
	  ->
	    let noOffset field = Field (field, NoOffset) in
	    let getOffset name = noOffset (getCompField compinfo name) in
	    let singleInit (name, expr) = getOffset name, SingleInit expr in
	    let inits = List.map singleInit [ "prev", zero;
					      "next", zero;
					      "signature", (mkString signature);
					      "count", siteCount;
					      "tuples", (mkAddrOrStartOf (var counterTuples)) ]
	    in
	    initinfo.init <- Some (CompoundInit (varinfo.vtype, inits));
	    global

	| GVar ({vname = "siteInfo";
		 vtype = TArray (elementType, None, attributes)}
		  as varinfo,
		_, location)
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
