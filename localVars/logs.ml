open Cil
open Loggers


let multimap transformer inputs =
  List.fold_left (fun prefix input -> prefix @ transformer input) [] inputs


class visitor loggers func = object
  inherit FunctionBodyVisitor.visitor

  initializer
    let dissectVar varinfo =
      let var = Var varinfo in
      
      let primitive logger location offset =
	let expr = Lval (var, offset) in
	[Call (None, logger,
	       [mkString location.file;
		kinteger IUInt location.line;
		mkString (Pretty.sprint 80 (d_exp () expr));
		expr],
	       location)]
      in

      let rec dissectField offset field =
	if field.fname == missingFieldName then
	  []
	else
	  dissect (Field (field, offset)) field.ftype

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
	      | FFloat -> loggers.double
	      | FDouble -> loggers.double
	      | FLongDouble -> loggers.longDouble
	    in
	    primitive format locUnknown offset
	| TInt (ikind, _) ->
	    let format =
	      match ikind with
	      | IChar -> loggers.char
	      | ISChar -> loggers.char
	      | IUChar -> loggers.char
	      | IShort -> loggers.short
	      | IUShort -> loggers.unsignedShort
	      | IInt -> loggers.int
	      | IUInt -> loggers.unsignedInt
	      | ILong -> loggers.long
	      | IULong -> loggers.unsignedLong
	      | ILongLong -> loggers.longLong
	      | IULongLong -> loggers.unsignedLongLong
	    in
	    primitive format locUnknown offset
	| TNamed ({ttype = ttype}, _) ->
	    dissect offset ttype
	| TPtr _ ->
	    primitive loggers.pointer locUnknown offset
	| TFun _
	| TVoid _
	  -> failwith "unexpected variable type"
      in
      dissect NoOffset varinfo.vtype
    in
    
    let calls = multimap dissectVar (func.sformals @ func.slocals) in
    let stmt = mkStmt (Instr calls) in
    dumpStmt defaultCilPrinter stderr 3 stmt

  method vstmt _ = DoChildren

  method vinst inst =
    ChangeTo [inst; SkipLog.call (Where.locationOf inst)]
end
