open Cil
open Mapconcat


let transform fundec factory =

  let updateFormal formal =
    if Tracker.trackable formal.vtype then
      let tracker = factory ("$" ^ formal.vname) formal.vtype in
      let update = tracker#update formal in
      update
    else
      []
  in

  match mapconcat updateFormal [] fundec.sformals with
  | [] -> ()
  | updates ->
      fundec.sbody.bstmts <- mkStmt (Instr updates) :: fundec.sbody.bstmts
