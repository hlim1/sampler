open Cil


let timestamps =
  Options.registerBoolean
    ~flag:"timestamps"
    ~desc:"record relative timestamps for each observed site"
    ~ident:"Timestamps"
    ~default:false


let set file =
  if !timestamps then
    let clock = var (FindGlobal.find "samplerClock" file) in
    let clockExp = Lval clock in
    fun (site : lval) location ->
      match typeOfLval site with
      | TComp ({cstruct = true} as compinfo, _) ->
	  let fieldInfo = getCompField compinfo "timestamp" in
	  let field = addOffsetLval (Field (fieldInfo, NoOffset)) site in
	  [Set (clock, increm clockExp 1, location);
	   Set (field, clockExp, location)]
      | other ->
	  ignore (bug "unexpected site type %a\n" d_type other);
	  failwith "internal error"
  else
    fun _ _ -> []
