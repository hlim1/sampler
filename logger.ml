open Cil
open OutputSet
open Pretty


type builder = location -> OutputSet.t -> instr list


let call file =

  let find name = FindFunction.find name file in

  let logSiteBegin = find "logSiteBegin" in
  let logSiteEnd = find "logSiteEnd" in
  
  let logChar = find "logChar" in
  let logSignedChar = find "logSignedChar" in
  let logUnsignedChar = find "logUnsignedChar" in
  let logInt = find "logInt" in
  let logUnsignedInt = find "logUnsignedInt" in
  let logShort = find "logShort" in
  let logUnsignedShort = find "logUnsignedShort" in
  let logLong = find "logLong" in
  let logUnsignedLong = find "logUnsignedLong" in
  let logLongLong = find "logLongLong" in
  let logUnsignedLongLong = find "logUnsignedLongLong" in
  let logFloat = find "logFloat" in
  let logDouble = find "logDouble" in
  let logLongDouble = find "logLongDouble" in
  let logPointer = find "logPointer" in

  fun location lvals ->
    let rec handlerForType = function
      | TInt (ikind, _) ->
	  (match ikind with
	  | IChar -> logChar
	  | ISChar -> logSignedChar
	  | IUChar -> logUnsignedChar
	  | IInt -> logInt
	  | IUInt -> logUnsignedInt
	  | IShort -> logShort
	  | IUShort -> logUnsignedShort
	  | ILong -> logLong
	  | IULong -> logUnsignedLong
	  | ILongLong -> logLongLong
	  | IULongLong -> logUnsignedLongLong)
      | TFloat (fkind, _) ->
	  (match fkind with
	  | FFloat -> logFloat
	  | FDouble -> logDouble
	  | FLongDouble -> logLongDouble)
      | TPtr _ -> logPointer
      | TNamed ({ttype = ttype}, _) -> handlerForType ttype
      | problematic ->
	  currentLoc := location;
	  ignore (bug "cannot log non-primitive type %a"
		    d_type problematic);
	  failwith "internal error"
    in
    
    let buildOne lval =
      let handler = handlerForType (typeOfLval lval) in
      let name = mkString (sprint 80 (d_lval () lval)) in
      Call (None, handler, [ name; Lval lval ], location)
    in
    
    let callBegin = Call (None, logSiteBegin,
			  [ mkString location.file;
			    kinteger IUInt location.line ],
			  location)
    in
    
    let callEnd = Call (None, logSiteEnd, [], location) in

    let folder lval calls =
      buildOne lval :: calls
    in

    callBegin :: OutputSet.fold folder lvals [callEnd]
