open Cil
open Ptranal


type resolution = Unknown | Known of varinfo list




let usePointsTo =
  Options.registerBoolean
    ~flag:"use-points-to"
    ~desc:"use a points-to analysis to resolve dynamic function calls"
    ~ident:"UsePointsTo"
    ~default:false


let analyze file =
  if !usePointsTo then
    begin
      prerr_endline "=== Points-to analysis active!";
      analyze_file file;
      compute_results false
    end

let funptrFilter lst =
  let isFunPtr varinfo =
    match varinfo.vtype with
    | TFun (_, _, _, _) ->
        (varinfo.vname <> "__builtin_alloca")
    | _ -> false
  in
  List.filter isFunPtr lst

module VarInfoSet = Set.Make( 
  struct
    let compare = Pervasives.compare
    type t = varinfo
  end )

let removeDuplicates lst =
  let accumulator = (fun acc v -> VarInfoSet.add v acc) in
  let uniques = List.fold_left accumulator VarInfoSet.empty lst in
  VarInfoSet.elements uniques

let resolve = function
  | (Var varinfo, NoOffset) ->
      Known [varinfo]
  | (Mem expression, NoOffset) ->
      if !usePointsTo then
	try
	  let resultList = resolve_exp expression in
	  let filtered = funptrFilter resultList in
	  let result = removeDuplicates filtered in
	  ignore (Pretty.eprintf "=== pta: %a --> [%a]\n"
		    d_exp expression
		    (Pretty.d_list ", " (fun () varinfo -> Pretty.text varinfo.vname)) result);
	  Known result
	with UnknownLocation ->
	  ignore (Pretty.eprintf "=== pta: %a --> ???\n" d_exp expression);
	  Unknown
      else
	Unknown
  | other ->
      ignore (bug "unexpected callee: %a\n" d_lval other);
      failwith "internal error"
