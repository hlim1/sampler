open Cil
open OutputSet
open Pretty


type builder = location -> OutputSet.t -> global list ref -> instr list

exception Missing of string


let constAttrs = [Attr ("const", [])]
let constCharType = TInt (IChar, constAttrs)
let constVoidPtrType = TPtr (TVoid constAttrs, [])


let nextTableauName =
  let nextTableauNum = ref 0 in
  fun () ->
    incr nextTableauNum;
    "_loggerTableau" ^ (string_of_int !nextTableauNum)


let call file =

  let logTableau = FindFunction.find "logTableau" file in

  let primitiveEnum =
    let rec search = function
      | GEnumTag ({ename = ename} as enuminfo, _) :: _
	when ename = "PrimitiveType" ->
	  enuminfo
      | _ :: rest ->
	  search rest
      | [] ->
	  raise (Missing "enum PrimitiveType")
    in
    search file.globals
  in
  let findEnum target =
    let rec search = function
      |	(name, exp) :: _ when name = target -> exp
      |	_ :: rest -> search rest
      |	[] -> raise (Missing target)
    in
    search primitiveEnum.eitems
  in
  
  let codeChar = findEnum "Char" in
  let codeSignedChar = findEnum "SignedChar" in
  let codeUnsignedChar = findEnum "UnsignedChar" in
  let codeInt = findEnum "Int" in
  let codeUnsignedInt = findEnum "UnsignedInt" in
  let codeShort = findEnum "Short" in
  let codeUnsignedShort = findEnum "UnsignedShort" in
  let codeLong = findEnum "Long" in
  let codeUnsignedLong = findEnum "UnsignedLong" in
  let codeLongLong = findEnum "LongLong" in
  let codeUnsignedLongLong = findEnum "UnsignedLongLong" in
  let codeFloat = findEnum "Float" in
  let codeDouble = findEnum "Double" in
  let codeLongDouble = findEnum "LongDouble" in
  let codePointer = findEnum "Pointer" in

  let rec typeCode = function
    | TInt (ikind, _) ->
	(match ikind with
	| IChar -> codeChar
	| ISChar -> codeSignedChar
	| IUChar -> codeUnsignedChar
	| IInt -> codeInt
	| IUInt -> codeUnsignedInt
	| IShort -> codeShort
	| IUShort -> codeUnsignedShort
	| ILong -> codeLong
	| IULong -> codeUnsignedLong
	| ILongLong -> codeLongLong
	| IULongLong -> codeUnsignedLongLong)
    | TFloat (fkind, _) ->
	(match fkind with
	| FFloat -> codeFloat
	| FDouble -> codeDouble
	| FLongDouble -> codeLongDouble)
    | TPtr _ -> codePointer
    | TNamed ({ttype = ttype}, _) -> typeCode ttype
    | problematic ->
	ignore (Errormsg.error "%s: cannot log non-primitive type %a"
		  file.fileName d_type problematic);
	failwith "internal error"
  in

  fun location lvals globals ->
    
    let rawBuffer name exp =
      let baseType = typeOf exp in
      let fieldType =
	if isConstant exp then
	  typeAddAttributes constAttrs baseType
	else
	  typeRemoveAttributes ["const"] baseType
      in
      (fieldType, name, exp)
    in
    
    let stringBuffer name string =
      let length = String.length string + 1 in
      (TArray (constCharType, Some (integer length), []), name, mkString string)
    in
       
    let folder =
      let nextFieldNum = ref 0 in
      fun lval rest ->
	let baseType = typeOfLval lval in
	let fieldType = if isPointerType baseType then
	  constVoidPtrType
	else
	  baseType
	in
	let suffix = "_" ^ (string_of_int !nextFieldNum) in
	incr nextFieldNum;
	stringBuffer ("expr" ^ suffix) (sprint 80 (d_lval () lval))
	:: rawBuffer ("type" ^ suffix) (mkCast (typeCode (typeOfLval lval)) charType)
	:: rawBuffer ("value" ^ suffix) (mkCast (Lval lval) fieldType)
	:: rest
    in
    
    let buffers =
      stringBuffer "file" location.file
      :: rawBuffer "line" (kinteger IUInt location.line)
      :: OutputSet.fold folder lvals [rawBuffer "end" (kinteger IChar 0)]
    in

    let tableauName = nextTableauName () in

    let tableauInfo =
      let fieldInfo _ =
	let shuffle (typ, name, _) = (name, typ, None, []) in
	List.map shuffle buffers
      in
      mkCompInfo true tableauName fieldInfo [Attr ("packed", [])]
    in
    
    let tableauType = TComp (tableauInfo, []) in
    let tableau = makeGlobalVar tableauName tableauType in
    tableau.vstorage <- Static;
    let tableauVar = Var tableau in

    let inits =
      let rec build fields buffers =
	match fields, buffers with
	| field :: fields, (typ, name, expr) :: buffers ->
	    assert (field.fname = name);
	    let offset = Field (field, NoOffset) in
	    let init =
	      if isConstant expr then
		SingleInit expr
	      else
		makeZeroInit typ
	    in
	    (offset, init) :: build fields buffers
	| [], [] ->
	    []
	| _ ->
	    raise (Invalid_argument "Logger.inits")
      in
      CompoundInit (tableauType, build tableauInfo.cfields buffers)
    in

    globals :=
      GCompTag (tableauInfo, location)
      :: GVar (tableau, Some inits, location)
      :: !globals;

    let callLogger = Call (None, logTableau,
			   [ mkAddrOf (tableauVar, NoOffset);
			     SizeOf tableauType ],
			   location)
    in

    let instrs =
      let rec build fields buffers =
	match fields, buffers with
	| field :: fields, (typ, name, expr) :: buffers ->
	    assert (field.fname = name);
	    if isConstant expr then
	      build fields buffers
	    else
	      Set ((tableauVar, Field (field, NoOffset)), expr, location)
	      :: build fields buffers
	| [], [] ->
	    [callLogger]
	| _ ->
	    raise (Invalid_argument "Logger.inits")
      in
      build tableauInfo.cfields buffers
    in

    instrs
