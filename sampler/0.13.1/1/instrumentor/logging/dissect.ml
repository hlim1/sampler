open Cil
open Pretty


let primitive lval outputs =
  outputs#add lval


let rec dissectField lval field =
  if field.fname != missingFieldName then
    dissect (addOffsetLval (Field (field, NoOffset)) lval) field.ftype
  else
    ignore


and dissect lval typ outputs =
  match typ with
  | TInt _
  | TPtr _
  | TFloat _ ->
      primitive lval outputs
	
  | TArray _ (* fix me *)
  | TEnum _ (* fix me *)
  | TBuiltin_va_list _
  | TFun _ ->
      ()

  | TNamed ({ttype = ttype}, _) ->
      dissect lval ttype outputs
	
  | TComp ({cfields = cfields}, _) ->
      let scanner field =
	dissectField lval field outputs
      in
      List.iter scanner cfields

  | TVoid _ ->
      failwith "unexpected variable type"
