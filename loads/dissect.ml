open Cil
open OutputSet
open Pretty


let primitive lval formatter =
  OutputSet.singleton
    (sprint 80 (chr '\t'
		  ++ d_lval () lval
		  ++ text " == %"
		  ++ text formatter
		  ++ chr '\n'),
     Lval lval)


let rec dissectField lval field =
  if field.fname == missingFieldName then
    OutputSet.empty
  else
    dissect (addOffsetLval (Field (field, NoOffset)) lval) field.ftype


and dissect lval = function
  | TArray _ -> (* fix me *)
      OutputSet.empty
	
  | TBuiltin_va_list _ ->
      OutputSet.empty
	
  | TComp ({cfields = cfields}, _) -> (* fix me *)
      let folder prior field =
	OutputSet.union prior (dissectField lval field)
      in
      List.fold_left folder OutputSet.empty cfields

  | TEnum _ -> (* fix me *)
      OutputSet.empty
	
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
	
  | TFun _ ->
      OutputSet.empty

  | TVoid _ ->
      failwith "unexpected variable type"
