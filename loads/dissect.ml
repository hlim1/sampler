open Cil
open Pretty


let primitive lval formatter =
  [sprint 80 (d_lval () lval
		++ text " == %"
		++ text formatter),
   Lval lval]


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
