open Cil


type info = {
    export : stmt;
    call : stmt;
    callee : exp;
    import : stmt;
    jump : stmt;
    landing : stmt;
    site : stmt;
  }

type infos = info list


let prepatch stmt =
  match stmt.skind with
  | Instr [Call (_, callee, _, _) as call] ->
      let info = {
	export = mkEmptyStmt ();
	call = mkStmtOneInstr call;
	callee = callee;
	import = mkEmptyStmt ();
	jump = mkEmptyStmt ();
	landing = mkEmptyStmt ();
	site = mkEmptyStmt ();
      }
      in
      let block = Block (mkBlock [info.export;
				  info.call;
				  info.import;
				  info.jump;
				  info.landing;
				  info.site])
      in
      stmt.skind <- block;
      info
  | _ ->
      failwith "can only prepatch isolated call instructions"
