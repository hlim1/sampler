open Cil
open SiteInfo


type branchProfileVar = { varinfo : varinfo;
			  compinfo : compinfo;
			  initinfo : initinfo }


class builder file =
  let branchProfile =
    let rec seek = function
      | GVar ({vname = "branchProfile";
	       vtype = TComp ({cstruct = true;
			       cname = "BranchProfile"} as compinfo,
			      []);
	       vstorage = Static} as varinfo,
	      ({init = None} as initinfo),
	      _) :: _
	->
	  {varinfo = varinfo; initinfo = initinfo; compinfo = compinfo}
      | _ :: rest ->
	  seek rest
      | [] ->
	  failwith "cannot find global variable \"branchProfile\""
    in
    seek file.globals
  in


  object (self)
    val mutable id = 0

    val sites = new SiteInfoQueue.container


    method private getField = getCompField branchProfile.compinfo


    method bump =
      let sitesField = self#getField "sites" in

      fun func location expression ->
	let local = var (makeTempVar func (typeOf expression)) in

	let bump =
	  let array = (Var branchProfile.varinfo, Field (sitesField, Index (integer id, NoOffset))) in
	  id <- id + 1;
	  Bump.bump location (Lval local) array
	in

	sites#add { location = location;
		    condition = expression };

	local, bump


    method register =
      let signature = Digest.file file.fileName in
      let noOffset field = Field (field, NoOffset) in
      let getOffset name = noOffset (self#getField name) in
      let singleInit name expr = getOffset name, SingleInit expr in
      let init = CompoundInit (branchProfile.varinfo.vtype,
			       [ singleInit "prev" zero;
				 singleInit "next" zero;
				 singleInit "signature" (mkString signature);
				 singleInit "count" (integer id);
				 let sitesField = self#getField "sites" in
				 let countersInit =
				   let countersType =
				     match sitesField.ftype with
				     | TArray (countersType, _, _) -> countersType
				     | _ -> failwith "bad sites field type"
				   in
				   CompoundInit (countersType, [])
				 in
				 (noOffset sitesField,
				  CompoundInit (sitesField.ftype,
						let arrayInit = ref [] in
						for slot = id downto 1 do
						  arrayInit := (Index (integer slot, NoOffset),
								countersInit)
						    :: !arrayInit
						done;
						!arrayInit))
			       ])
      in
      branchProfile.initinfo.init <- Some init;


      let siteInfoInit = SiteInfos.serialize sites signature in
      let siteInfoSize = Some (integer (String.length siteInfoInit)) in
      let truncator = function
	| GVar ({vname = "siteInfo";
		 vtype = TArray (TInt (IChar, [Attr("const", [])]) as elementType, None, attributes);
		 vstorage = Static} as varinfo,
		({init = None}),
		location)
	  ->
	    GVar ({varinfo with vtype = TArray (elementType, siteInfoSize, attributes) },
		  { init = Some (SingleInit (mkString siteInfoInit)) },
		  location)
	| other ->
	    other
      in
      mapGlobals file truncator

  end
