open Cil
open Rmtmps


let id = ref 0


let findCompInfo file =
  let rec seek = function
    | GCompTag ({ cstruct = true; cname = "BranchProfile" } as compinfo, _) :: _ ->
	compinfo
    | _ :: rest ->
	seek rest
    | [] ->
	raise Not_found
  in
  seek file.globals


let build file =
  let compInfo = findCompInfo file in
  let compType = TComp(compInfo, []) in
  let fieldOffset field = Field (field, NoOffset) in
  let getField = getCompField compInfo in
  let arrayField = getField "counters" in
  let arrayOffset = fieldOffset arrayField in

  fun func location (expression : exp) ->
    let global =
      incr id;
      let result = makeGlobalVar ("branch_profile_" ^ string_of_int !id) compType in
      result.vstorage <- Static;
      result
    in

    let declaration =
      let init tag expr = fieldOffset (getField tag), SingleInit expr in
      let initStr tag str = init tag (mkString str) in
      let initNum tag num = init tag (kinteger IUInt num) in
      
      GVar (global,
	    { init = Some
		(CompoundInit
		   (compType,
		    [ init "prev" zero;
		      init "next" zero;
		      arrayOffset, makeZeroInit arrayField.ftype;
		      initStr "file" location.file;
		      initNum "line" location.line;
		      initStr "function" func.svar.vname;
		      initStr "condition" (Pretty.sprint max_int (d_exp () expression));
		      initNum "id" !id
		    ])) },
	    location)
    in

    let local = var (makeTempVar func (typeOf expression)) in

    let bump =
      let array = (Var global, arrayOffset) in
      Bump.bump func location (Lval local) array
    in

    local, bump, declaration


let register file =
  removeUnusedTemps file;

  let profiles =
    try
      let target = findCompInfo file in

      let rec filter = function
	| GVar ({ vtype = TComp (compinfo, _) } as varinfo, _, _) :: globals
	  when compinfo == target ->
	    varinfo :: filter globals
	| _ :: globals ->
	    filter globals
	| [] ->
	    []
      in

      filter file.globals

    with Not_found -> []
  in

  if profiles != [] then
    begin
      let call helper profile = Call (None, Lval (var helper), [mkAddrOf (var profile)], profile.vdecl) in
      let calls helper = List.map (call helper) profiles in
      let build timing name helper =
	let func = emptyFunction name in
	func.svar.vstorage <- Static;
	func.svar.vattr <- [Attr (timing, [])];
	func.sbody.bstmts <- [mkStmt (Instr (calls helper))];
	GFun (func, locUnknown)
      in
      
      let registerHelper = FindFunction.find "registerBranchProfile" file in
      let unregisterHelper = FindFunction.find "unregisterBranchProfile" file in
      let registerAll = build "constructor" "registerBranchProfiles" registerHelper in
      let unregisterAll = build "destructor" "unregisterBranchProfiles" unregisterHelper in

      file.globals <- file.globals @ [registerAll; unregisterAll]
    end
