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
	    Some
	      (CompoundInit
		 (compType,
		  [ init "next" zero;
		    arrayOffset, makeZeroInit arrayField.ftype;
		    initStr "file" location.file;
		    initNum "line" location.line;
		    initStr "function" func.svar.vname;
		    initStr "left" left.name;
		    initStr "right" right.name;
		    initNum "id" !id
		  ])),
	    location)
    in

    let bump =
      let array = (Var global, arrayOffset) in
      Bump.bump func location left.exp right.exp array
    in

    bump, declaration


let register file =
  let compInfo = findCompInfo file in
  let callee = FindFunction.find "registerInvariant" file in

  let invariants =
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

  if invariants != [] then
    let call invariant = Call (None, Lval (var callee), [mkAddrOf (var invariant)], invariant.vdecl) in
    let calls = List.map call invariants in
    
    let func = emptyFunction "registerInvariants" in
    func.svar.vstorage <- Static;
    func.svar.vattr <- [Attr ("constructor", [])];
    func.sbody.bstmts <- [mkStmt (Instr calls)];

    file.globinit <- Some func
