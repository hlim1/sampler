open Cil


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

      let removeUnmarked stmt =
	if stmt.sid != -2 then
	  stmt.skind <- Instr []
      in
      List.iter removeUnmarked stmts
