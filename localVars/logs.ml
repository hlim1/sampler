open Cil
open Pretty
open Str


let multimap transformer =
  List.fold_left (fun prefix input -> prefix @ transformer input) []


class visitor logger func = object (self)
  inherit FunctionBodyVisitor.visitor

  val callLogger =
    let dissectVar varinfo =
      let var = Var varinfo in
      
      let primitive format offset =
	let expr = Lval (var, offset) in
	[(Pretty.sprint 80 (d_exp () expr ++ text " == %" ++ text format),
	  expr)]
      in

      let rec dissectField offset field =
	if field.fname == missingFieldName then
	  []
	else
	  dissect (addOffset (Field (field, NoOffset)) offset) field.ftype

      and dissect offset = function
	| TArray _ ->
          (* fix me *)
	    []
	| TBuiltin_va_list _ ->
	    []
	| TComp ({cfields = cfields}, _) ->
	    multimap (dissectField offset) cfields
	| TEnum _ ->
          (* fix me *)
	    []
	| TFloat (fkind, _) ->
	    let format =
	      match fkind with
	      | FFloat -> "g"
	      | FDouble -> "g"
	      | FLongDouble -> "Lg"
	    in
	    primitive format offset
	| TInt (ikind, _) ->
	    let format =
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
	    primitive format offset
	| TNamed ({ttype = ttype}, _) ->
	    dissect offset ttype
	| TPtr _ ->
	    primitive "p" offset
	| TFun _
	| TVoid _
	  -> failwith "unexpected variable type"
      in

      dissect NoOffset varinfo.vtype
    in
    
    let notTemporary {vname = vname} =
      let pattern = regexp "^__\|^tmp$\|^tmp___[0-9]+$" in
      not (string_match pattern vname 0)
    in

    let outputs = multimap dissectVar (func.sformals @ List.filter notTemporary func.slocals) in
    let formats, arguments = List.split outputs in
    let format = mkString ("%s:%u:\n\t" ^ String.concat "\n\t" formats ^ "\n") in
    
    fun inst ->
      let where = Where.locationOf inst in
      Call (None, logger,
	    format
	    :: mkString where.file
	    :: kinteger IUInt where.line
	    :: arguments,
	    where)

  method vstmt _ = DoChildren

  method vinst inst =
    self#queueInstr [callLogger inst];
    SkipChildren
end
