open Cil


let specializeEmptyRegions = ref true
let specializeSingletonRegions = ref true

let _ =
  Options.registerBoolean
    specializeEmptyRegions
    ~flag:"specialize-empty-regions"
    ~desc:"specialize countdown checks for regions with no sampling sites"
    ~ident:"SpecializeEmptyRegions";

  Options.registerBoolean
    specializeSingletonRegions
    ~flag:"specialize-singleton-regions"
    ~desc:"specialize countdown checks for regions with exactly one sampling site"
    ~ident:"SpecializeSingletonRegions"


let findGlobal =
  let predicate = function
    | TInt _ -> true
    | _ -> false
  in
  FindGlobal.find predicate "nextEventCountdown"


let findReset = FindFunction.find "getNextEventCountdown"


let find file = (findGlobal file, findReset file)


class countdown file =
  let global = findGlobal file in
  let reset = findReset file in
  fun fundec ->
    let local = var (makeTempVar fundec ~name:"localEventCountdown" uintType) in

    object (self)
      method decrement location =
	Instr [Set (local, increm (Lval local) (-1), location)]

      method export =
	Set (global, (Lval local), locUnknown)

      method import =
	Set (local, (Lval global), locUnknown)

      method checkThreshold location weight instrumented original =
	let gotoOriginal = Goto (ref original, location) in
	let gotoInstrumented = Goto (ref instrumented, location) in
	match weight with
	| 0 when !specializeEmptyRegions -> gotoOriginal
	| 1 when !specializeSingletonRegions -> gotoInstrumented
	| _ ->
	    let within = kinteger IUInt weight in
	    let predicate = BinOp (Gt, Lval local, within, intType) in
	    let choice = If (predicate,
			     mkBlock [mkStmt gotoOriginal],
			     mkBlock [mkStmt gotoInstrumented],
			     location) in
	    Choices.add choice;
	    choice

      method decrementAndCheckZero skind =
	let location = get_stmtLoc skind in
	let callReset = mkStmtOneInstr (Call (Some local, reset, [], location)) in
	Block (mkBlock [ mkStmt (self#decrement location);
			 mkStmt (If (BinOp (Eq, Lval local, zero, intType),
				     mkBlock [ mkStmt skind; callReset ],
				     mkBlock [],
				     location)) ])
    end
