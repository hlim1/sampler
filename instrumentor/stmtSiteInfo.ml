open Cil

class c func inspiration statement =
  object
    inherit SiteInfo.c func inspiration as super

    method! print =
      let rec printStmt stmt =
	let printStmt1 stmts =
	  match stmts with
	    [] -> []
	    | [s] -> printStmt s
	    | s :: _ -> printStmt s
	in
	let printStmt2 stmts =
	  match stmts with
	    [] -> []
	    | [s] -> printStmt s
	    | [_; s] -> printStmt s
	    | _ :: stmts -> printStmt1 stmts
	in
	let printStmtOption stmtOpt =
	  match stmtOpt with
	    None -> printStmt dummyStmt (* todo: skip printing dummy statements (minor performance bug) *)
	    | Some s -> printStmt s
	in
	match stmt.skind with
	  Block (b) -> printStmt2 b.bstmts
	  | Loop (_, _, _, stmt) -> printStmtOption stmt
	  | If (exp, _, _, _) -> super#print @ [dn_exp () exp]
	  | Switch (exp, _, _, _) -> super#print @ [dn_exp () exp]
	  | _ -> super#print @ [dn_stmt () stmt]
      in
      printStmt statement
  end
