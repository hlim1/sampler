open Cil
open Foreach
  
  
let collect headers =
  let arrived = new StmtSet.container
  and departed = new StmtSet.container in

  let rec explore stmt =
    arrived#add stmt;
    
    foreach stmt.succs begin
      fun succ ->
	if not (arrived#mem succ) then
	  explore succ
	else if not (departed#mem succ) then
	  headers#add (stmt, succ)
    end;

    departed#add stmt
  in
  
  explore
