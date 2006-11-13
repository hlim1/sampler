open Cil


let timestamps =
  Options.registerBoolean
    ~flag:"timestamps"
    ~desc:"record relative timestamps for each observed site"
    ~ident:"Timestamps"
    ~default:false


let set file =
  if !timestamps then
    let stampField site =
      match typeOfLval site with
      | TComp ({cstruct = true} as compinfo, _) ->
	  let fieldInfo = getCompField compinfo "timestamp" in
	  addOffsetLval (Field (fieldInfo, NoOffset)) site
      | other ->
	  ignore (bug "unexpected site type %a\n" d_type other);
	  failwith "internal error"
    in

    if Threads.enabled () then
      let stamper = Lval (var (FindFunction.find "samplerClockTick" file)) in
      fun site location ->
	[Call (None, stamper, [mkAddrOf (stampField site)], location)]
    else
      let clock = var (FindGlobal.find "samplerClock" file) in
      let clockExp = Lval clock in
      fun site location ->
	[Set (clock, increm clockExp 1, location);
	 Set (stampField site, clockExp, location)]

  else
    fun _ _ -> []
