open Cil


type info = {
    export : stmt;
    call : stmt;
    callee : lval;
    import : stmt;
    jump : stmt;
    landing : stmt;
    site : stmt;
  }

type infos = info list


let prepatch stmt =
  match stmt.skind with
  | Instr [Call (_, Lval callee, _, _) as call] ->
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

  | Instr [Call (_, callee, _, _) as call] ->
      ignore (bug "unexpected non-lval callee: %a" d_exp callee);
      failwith "internal error"

  | _ ->
      ignore (bug "can only prepatch isolated call instructions");
      failwith "internal error"
