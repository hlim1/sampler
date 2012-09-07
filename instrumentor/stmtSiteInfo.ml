open Cil
open Pretty

class c func inspiration statement =
  object
    inherit SiteInfo.c func inspiration as super

    method! print =
      let rec printStmt stmt =
	let rec printStmts stmts =
	  match stmts with
	    [] -> []
	    | [_; s] -> printStmt s
	    | _ :: l -> printStmts l
	in
	let printStmtOption stmtOpt =
	  match stmtOpt with
	    None -> printStmt dummyStmt (* todo: skip printing dummy statements (minor performance bug) *)
	    | Some s -> printStmt s
	in
	match stmt.skind with
	  Block (b) -> printStmts b.bstmts
	  | Loop (_, _, _, stmt) -> printStmtOption stmt
	  | If (exp, _, _, _) -> super#print @ [dn_exp () exp]
	  | Switch (exp, _, _, _) -> super#print @ [dn_exp () exp]
	  | _ -> super#print @ [dn_stmt () stmt]
      in
      printStmt statement
  end
