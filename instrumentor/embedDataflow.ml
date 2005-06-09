open Cil
open Pretty


let saveDataflow =
  Options.registerString
    ~flag:"save-dataflow"
    ~desc:"save data flow information in the named file"
    ~ident:""


let isInterestingType = isIntegralType


let format_receiver lval =
  if isInterestingType (typeOfLval lval) then
    match lval with
    | Var var, NoOffset -> Some (text var.vname)
    | Mem _, NoOffset -> Some (chr '*')
    | _, Field _ -> None
    | _, Index _ -> None
  else
    None


let format_sender expr =
    if isInterestingType (typeOf expr) then
      match expr with
      | Lval (Var var, NoOffset) -> Some (text var.vname)
      | Lval (Mem _, NoOffset) -> Some (chr '*')
      | other ->
	  match isInteger other with
	  | Some constant -> Some (text (Int64.to_string constant))
	  | None -> Some (chr '*')
    else
      None


let embedGlobal channel = function
  | GVar (var, init, _)
    when isInterestingType var.vtype ->
      let sender = match init.init with
      | None -> num 0
      | Some (SingleInit expr) ->
	  begin
	    match format_sender expr with
	    | None ->
		ignore (bug "interesting receiver with uninteresting sender");
		failwith "internal error"
	    | Some sender -> sender
	  end
      | Some (CompoundInit _) ->
	  chr '*'
      in
      ignore (fprintf channel "%s\t%a\n" var.vname insert sender)
  | _ ->
      ()


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
	      match format_sender sender with
	      | None -> noop
	      | Some sender -> '<', [sender]
	    end

	| Instr [Set (receiver, sender, _)] ->
	    begin
	      match format_receiver receiver with
	      | None -> noop
	      | Some receiver ->
		  match format_sender sender with
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
		match format_receiver receiver with
		| None -> chr '.'
		| Some receiver -> receiver
	    in
	    let senders = List.fold_right
		(fun sender senders ->
		  match format_sender sender with
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
		    match format_receiver receiver with
		    | None -> receivers
		    | Some receiver -> receiver :: receivers)
		  [] receivers
	    in
	    '!', receivers

	| Instr _ ->
	    ignore (bug "instr should have been atomized");
	    failwith "internal error"

	| If _ ->
	    noop

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
