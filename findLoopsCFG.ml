open Cil
open Dominators
open Foreach

  
let isLoopHeader dom stmt = List.exists (dom#dominates stmt) stmt.preds

    
let naturalLoop m n =
  let stack = new StackClass.container in
  let loop = new StmtSet.container in
  
  loop#add m;
  if m != n then
    begin
      loop#add n;
      stack#push m
    end;

  while not stack#isEmpty do
    let p = stack#pop in
    
    foreach p.preds begin
      fun q ->
	if not (loop#mem q) then
	  begin
	    loop#add q;
	    stack#push q
	  end
    end
  done;

  loop


class visitor = object
  inherit FunctionBodyVisitor.visitor
      
  method vfunc func =
    let (_, stmts) as cfg = Cfg.cfg func in
    let dom = computeDominators cfg in

    let headers = List.filter (isLoopHeader dom) stmts in
    ignore(Pretty.printf "loop headers according to dominator tree:@!  @[%a@]@!"
	     Utils.d_stmts headers);

    SkipChildren

end
    
;;

ignore(TestHarness.main ["FindLoopsCFG", visitCilFileSameGlobals new visitor])
