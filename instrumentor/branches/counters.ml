open Cil
open SiteInfo


class builder file =
  object (self)
    val mutable id = 0
    val sites = new SiteInfoQueue.container
    val counterTuples = FindGlobal.find "counterTuples" file


    method bump func location expression =
      let local = var (makeTempVar func (typeOf expression)) in

      let bump =
	let slice = (Var counterTuples, Index (integer id, NoOffset)) in
	id <- id + 1;
	Bump.bump location (Lval local) slice
      in

      sites#add { location = location; condition = expression };
      local, bump


    method register =
      let signature = Digest.file file.fileName in
      let siteCount = integer id in

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
	    let init = SiteInfos.serialize sites signature in
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
