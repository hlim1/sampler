open Cil
open Rmtmps


type operand = {
    exp : exp;
    name : string;
  }


let id = ref 0


let findCompInfo file =
  let rec seek = function
    | GCompTag ({ cstruct = true; cname = "Invariant" } as compinfo, _) :: _ ->
	compinfo
    | _ :: rest ->
	seek rest
    | [] ->
	raise Not_found
  in
  seek file.globals


let invariant file =
  let compInfo = findCompInfo file in
  let compType = TComp(compInfo, []) in
  let basicField field = Field (field, NoOffset) in
  let getField = getCompField compInfo in
  let arrayField = getField "counters" in
  let arrayOffset = basicField arrayField in

  fun func location left right ->
    let global =
      incr id;
      let result = makeGlobalVar ("invariant_" ^ string_of_int !id) compType in
      result.vstorage <- Static;
      result
    in

    let declaration =
      let init tag expr = basicField (getField tag), SingleInit expr in
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
		      initStr "left" left.name;
		      initStr "right" right.name;
		      initNum "id" !id
		    ])) },
	    location)
    in

    let bump =
      let array = (Var global, arrayOffset) in
      Bump.bump func location left.exp right.exp array
    in

    bump, declaration


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
      
      let registerHelper = FindFunction.find "registerInvariant" file in
      let unregisterHelper = FindFunction.find "unregisterInvariant" file in
      let registerAll = build "constructor" "registerInvariants" registerHelper in
      let unregisterAll = build "destructor" "unregisterInvariants" unregisterHelper in

      file.globals <- file.globals @ [registerAll; unregisterAll]
    end
