open Cil
open OutputSet
open Pretty


let primitive lval =
  OutputSet.singleton lval


let rec dissectField lval field =
  if field.fname == missingFieldName then
    OutputSet.empty
  else
    dissect (addOffsetLval (Field (field, NoOffset)) lval) field.ftype


and dissect lval = function
  | TInt _
  | TPtr _
  | TFloat _ ->
      primitive lval
	
  | TArray _ (* fix me *)
  | TEnum _ (* fix me *)
  | TBuiltin_va_list _
  | TFun _ ->
      OutputSet.empty

  | TNamed ({ttype = ttype}, _) ->
      dissect lval ttype
	
  | TComp ({cfields = cfields}, _) ->
      let folder prior field =
	OutputSet.union prior (dissectField lval field)
      in
      List.fold_left folder OutputSet.empty cfields

  | TVoid _ ->
      failwith "unexpected variable type"
