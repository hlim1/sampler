open Cil
open Pretty


let primitive lval formatter =
  let expr = Lval lval in
  [Pretty.sprint 80 (d_exp () expr
		       ++ text " <- %"
		       ++ text formatter),
   expr]


let rec dissectField lval field =
  if field.fname == missingFieldName then
    []
  else
    dissect (addOffsetLval (Field (field, NoOffset)) lval) field.ftype


and dissect lval = function
  | TArray _ -> (* fix me *)
      []
  | TBuiltin_va_list _ ->
      []
  | TComp ({cfields = cfields}, _) -> (* fix me *)
      let folder prior field =
	prior @ dissectField lval field
      in
      List.fold_left folder [] cfields

  | TEnum _ -> (* fix me *)
      []
  | TFloat (fkind, _) ->
      let formatter =
	match fkind with
	| FFloat -> "g"
	| FDouble -> "g"
	| FLongDouble -> "Lg"
      in
      primitive lval formatter
  | TInt (ikind, _) ->
      let formatter =
	match ikind with
	| IChar -> "hhd"
	| ISChar -> "hhd"
	| IUChar -> "hhd"
	| IShort -> "hd"
	| IUShort -> "hu"
	| IInt -> "d"
	| IUInt -> "u"
	| ILong -> "ld"
	| IULong -> "lu"
	| ILongLong -> "lld"
	| IULongLong -> "llu"
      in
      primitive lval formatter
  | TNamed ({ttype = ttype}, _) ->
      dissect lval ttype
  | TPtr _ ->
      primitive lval "p"
  | TFun _
  | TVoid _
    -> failwith "unexpected variable type"


let insert logger clones sites =

  let insertOne original (lval, where) =
    let instrumented = ClonesMap.findCloneOf clones original in
    let formats, arguments = List.split (dissect lval (typeOfLval lval)) in
    let format = ("%s:%u:\n\t" ^ String.concat "\n\t" formats ^ "\n") in
    let call = 
      Call (None, logger,
	    mkString format
	    :: mkString where.file
	    :: kinteger IUInt where.line
	    :: arguments,
	    where)
    in
    let block = Block (mkBlock [mkStmt instrumented.skind;
				mkStmtOneInstr call])
    in
    instrumented.skind <- block
  in

  sites#iter insertOne
