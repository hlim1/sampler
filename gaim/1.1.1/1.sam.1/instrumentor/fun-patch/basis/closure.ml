open Cil


let build file =
  let const = Attrs.const in
  
  let statics =
    let rec findStatics = function
      | [] ->
	  []
      | global :: rest ->
	  match global with
	  | GVarDecl (varinfo, _)
	  | GFun ({svar = varinfo}, _)
	    when varinfo.vstorage == Static ->
	      varinfo :: findStatics rest
	  | _ ->
	      findStatics rest
    in
    findStatics file.globals
  in

  let compinfo =
    let fields =
      let makeFieldInfo static =
	(static.vname, TPtr (static.vtype, const), None, [])
      in
      List.map makeFieldInfo statics
    in
    mkCompInfo
      true
      "$statics"
      (fun _ -> fields)
      []
  in

  let init =
    let inits =
      let makeFieldInit static field =
	(Field (field, NoOffset),
	 SingleInit (mkAddrOf (var static)))
      in
      let folder inits static field =
	makeFieldInit static field :: inits
      in
      List.fold_left2 folder [] statics compinfo.cfields
    in
    CompoundInit (TComp (compinfo, []), inits)
  in
  
  let varinfo = makeGlobalVar "$statics" (TComp (compinfo, const)) in
  varinfo.vstorage <- Static;
  file.globals <-
    GCompTagDecl (compinfo, locUnknown)
    :: GVarDecl (varinfo, locUnknown)
    :: file.globals @ [GCompTag (compinfo, locUnknown);
		       GVar (varinfo, Some init, locUnknown)];

  varinfo
