open Cil
open OutputSet
open Pretty


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
      |	(name, exp, _) :: _ when name = target -> exp
      |	_ :: rest -> search rest
      |	[] -> raise (Missing target)
    in
    search primitiveEnum.eitems
  in
  
  let codeInt8 = findEnum "Int8" in
  let codeUInt8 = findEnum "UInt8" in
  let codeInt16 = findEnum "Int16" in
  let codeUInt16 = findEnum "UInt16" in
  let codeInt32 = findEnum "Int32" in
  let codeUInt32 = findEnum "UInt32" in
  let codeInt64 = findEnum "Int64" in
  let codeUInt64 = findEnum "UInt64" in
  let codeFloat32 = findEnum "Float32" in
  let codeFloat64 = findEnum "Float64" in
  let codeFloat96 = findEnum "Float96" in
  let codePointer32 = findEnum "Pointer32" in

  let rec typeCode typ =
    match typ with
    | TInt (ikind, _) ->
	(match isSigned ikind, bitsSizeOf typ with
	| true, 8 -> codeInt8
	| false, 8 -> codeUInt8
	| true, 16 -> codeInt16
	| false, 16 -> codeUInt16
	| true, 32 -> codeInt32
	| false, 32 -> codeUInt32
	| true, 64 -> codeInt64
	| false, 64 -> codeUInt64
	| _, other ->
	    ignore (Errormsg.error "%s: cannot log %d-bit integer"
		      file.fileName other);
	    failwith "internal error")
    | TFloat _ ->
	(match bitsSizeOf typ with
	| 32 -> codeFloat32
	| 64 -> codeFloat64
	| 96 -> codeFloat96
	| other ->
	    ignore (Errormsg.error "%s: cannot log %d-bit float"
		      file.fileName other);
	    failwith "internal error")
    | TPtr _ ->
	(match bitsSizeOf typ with
	| 32 -> codePointer32
	| other ->
	    ignore (Errormsg.error "%s: cannot log %d-bit pointer"
		      file.fileName other);
	    failwith "internal error")
    | TNamed ({ttype = ttype}, _) -> typeCode ttype
    | TVoid _
    | TArray _
    | TFun _
    | TComp _
    | TEnum _
    | TBuiltin_va_list _ as problematic ->
	ignore (Errormsg.error "%s: cannot log non-primitive type %a"
		  file.fileName d_type problematic);
	failwith "internal error"
  in

  fun globals location (lvals : OutputSet.container) ->
    
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
      :: lvals#fold folder [rawBuffer "end" (kinteger IChar 0)]
    in

    let tableauName = nextTableauName () in

    let tableauInfo =
      let fieldInfo _ =
	let shuffle (typ, name, _) = (name, typ, None, [], locUnknown) in
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
