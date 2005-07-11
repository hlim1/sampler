open Cil
open Pretty


let saveDataflow =
  Options.registerString
    ~flag:"save-dataflow"
    ~desc:"save data flow information in the named file"
    ~ident:""


type value = Unknown | Complex | Simple of doc


let isInterestingType = isIntegralType


let simple = function
  | Complex -> None
  | Unknown -> Some (chr '*')
  | Simple doc -> Some doc


let format_receiver lval =
  if isInterestingType (typeOfLval lval) then
    match lval with
    | Var var, NoOffset -> Simple (text var.vname)
    | Mem _, NoOffset -> Unknown
    | _, Field _ -> Complex
    | _, Index _ -> Complex
  else
    Complex


let format_sender expr =
    if isInterestingType (typeOf expr) then
      match expr with
      | Lval (Var var, NoOffset) -> Simple (text var.vname)
      | Lval (Mem _, NoOffset) -> Unknown
      | other ->
	  match isInteger other with
	  | Some constant -> Simple (text (Int64.to_string constant))
	  | None -> Unknown
    else
      Complex


let storageCode var =
  match var.vstorage with
  | Extern -> '&'
  | Static when var.vaddrof -> '&'
  | Static -> '-'
  | NoStorage | Register -> '+'


let embedGlobal channel = function
  | GVarDecl (var, _)
    when isInterestingType var.vtype ->
      ignore (fprintf channel "%c%s\n" (storageCode var) var.vname)

  | GVar (var, init, _)
    when isInterestingType var.vtype ->
      let sender = match init.init with
      | None -> num 0
      | Some (SingleInit expr) ->
	  begin
	    match format_sender expr with
	    | Complex ->
		ignore (bug "interesting receiver with uninteresting sender");
		failwith "internal error"
	    | Simple sender -> sender
	    | Unknown -> chr '*'
	  end
      | Some (CompoundInit _) ->
	  chr '*'
      in
      ignore (fprintf channel "%c%s\t%a\n" (storageCode var) var.vname insert sender)

  | _ ->
      ()


let rec simpleCondition =
  let isComparison = function
    | Lt | Gt | Le | Ge | Eq | Ne -> true
    | _ -> false
  in
  let negate = function
    | Lt -> Ge
    | Gt -> Le
    | Le -> Gt
    | Ge -> Lt
    | Eq -> Ne
    | Ne -> Eq
    | other ->
	ignore (bug "cannot negate operator \"%a\"" d_binop other);
	failwith "internal error"
  in
  function
    | BinOp(op, left, right, _)
      when isComparison op ->
	begin
	  match format_sender left, format_sender right with
	  | Simple left, Simple right ->
	      Some (op, left, right)
	  | _ ->
	      None
	end
    | UnOp(LNot, subcondition, _) ->
	begin
	  match simpleCondition subcondition with
	  | None -> None
	  | Some (op, left, right) ->
	      Some (negate op, left, right)
	end
    | Lval (Var var, NoOffset) ->
	Some (Ne, text var.vname, num 0)
    | _ ->
	None



class visitor file digest channel =
  object (self)
    inherit FunctionBodyVisitor.visitor

    method vfunc fundec =
      ignore (fprintf channel "%s\n" fundec.svar.vname);
      let printVars vars =
	let isInterestingVar var = isInterestingType var.vtype in
	let noteworthy = List.filter isInterestingVar vars in
	let format_var () var =
	  if var.vaddrof then
	    chr '&' ++ text var.vname
	  else
	    text var.vname
	in
	ignore (fprintf channel "%a\n" (d_list "\t" format_var) noteworthy)
      in
      printVars fundec.sformals;
      printVars fundec.slocals;
      ChangeDoChildrenPost (fundec, fun _ -> output_char channel '\n'; fundec)

    method vstmt statement =
      let flag, args =
	let noop = '~', [] in
	match statement.skind with
	| Return (Some sender, _) ->
	    begin
	      match simple (format_sender sender) with
	      | None -> noop
	      | Some sender -> '<', [sender]
	    end

	| Instr [Set (receiver, sender, _)] ->
	    begin
	      match simple (format_receiver receiver) with
	      | None -> noop
	      | Some receiver ->
		  match simple (format_sender sender) with
		  | None ->
		      ignore (bug "interesting receiver with uninteresting sender");
		      failwith "internal error"
		  | Some sender ->
		      '=', [receiver; sender]
	    end

	| Instr [Call (receiver, _, senders, _)] ->
	    let receiver = match receiver with
	    | None -> chr '.'
	    | Some receiver ->
		match simple (format_receiver receiver) with
		| None -> chr '.'
		| Some receiver -> receiver
	    in
	    let senders = List.fold_right
		(fun sender senders ->
		  match simple (format_sender sender) with
		  | None -> senders
		  | Some sender -> sender :: senders)
		senders []
	    in
	    '>', receiver :: senders

	| Instr [Asm (_, _, receivers, _, clobbers, _)] ->
	    let receivers =
	      if List.mem "memory" clobbers then
		[chr '!']
	      else
		List.fold_left
		  (fun receivers (_, receiver) ->
		    match simple (format_receiver receiver) with
		    | None -> receivers
		    | Some receiver -> receiver :: receivers)
		  [] receivers
	    in
	    '!', receivers

	| Instr [] ->
	    noop

	| Instr _ ->
	    ignore (bug "instr should have been atomized");
	    failwith "internal error"

	| If (condition, _, _, _) ->
	    begin
	      match simpleCondition condition with
	      | None -> noop
	      | Some (op, left, right) ->
		  '?', [d_binop () op; left; right]
	    end

	| _ ->
	    noop
      in
      ignore (fprintf channel "%c%a\n" flag (d_list "\t" insert) args);
      DoChildren

  end


let visit file digest =
  if !saveDataflow <> "" then
    TestHarness.time "saving dataflow information"
      (fun () ->
	let channel = open_out !saveDataflow in
	Printf.fprintf channel
	  "*\tdataflow\t0.1\n%s\n"
	  (Digest.to_hex (Lazy.force digest));

	iterGlobals file (embedGlobal channel);
	output_char channel '\n';

	let visitor = new visitor file digest channel in
	visitCilFileSameGlobals (visitor :> cilVisitor) file;
	output_char channel '\n';
	close_out channel)
