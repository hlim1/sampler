open Cil


let rec markBlock { bstmts = bstmts } =
  let rec markStmt stmt =
    let markedSelf = stmt.sid == -2 in

    let markIfChild childMarked =
      if childMarked then
	stmt.sid <- -2;
      childMarked || markedSelf
    in

    match stmt.skind with
    | Instr _
    | Return _
    | Goto _
    | Break _
    | Continue _ ->
	markedSelf

    | If (_, trueBranch, falseBranch, _) ->
	let markedTrue = markBlock trueBranch in
	let markedFalse = markBlock falseBranch in
	markIfChild (markedTrue || markedFalse)

    | Switch (_, body, _, _)
    | Loop (body, _, _, _)
    | Block body ->
	markIfChild (markBlock body)
  in
  let folder marked stmt =
    markStmt stmt || marked
  in
  List.fold_left folder false bstmts


let visit func =
  match func.sbody.bstmts with
  | [] -> ()
  | entry :: _ ->
      let stmts = computeCFGInfo func false in

      let rec mark stmt =
	if stmt.sid != -2 then
	  begin
	    stmt.sid <- -2;
	    List.iter mark stmt.succs
	  end
      in
      mark entry;

      ignore (markBlock func.sbody);

      let removeUnmarked = function
	| { sid = -2 } ->
	    ()
	| stmt ->
	    stmt.skind <- Instr []
      in
      List.iter removeUnmarked stmts
