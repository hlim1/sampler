open Cil
open Printf


let bad message printer thing =
  try ignore(error message printer thing)
  with Errormsg.Error -> ()
    
    
let checkLvalue = function
  | (Mem Lval (Var _, NoOffset), NoOffset) -> ()
  | (Var _, _) -> ()
  | other -> bad "complex lvalue: %a" d_lval other
	
	
class visitor = object
  inherit FunctionBodyVisitor.visitor

  method vstmt _ = DoChildren

  method vinst inst =
    begin
      match inst with
      | Set (lval, rval, _) ->
	  begin
	    checkLvalue lval;
	    match lval with
	    | (Mem _, _) ->
		begin
		  match rval with
		  | Lval (Var _, NoOffset) -> ()
		  | other -> bad "complex rvalue: %a" d_exp other
		end
	    | _ -> ()
	  end
      | Call (Some lval, _, _, _) ->
	  checkLvalue lval
      | _ -> ()
    end;
    
    SkipChildren
end


let phase _ =
  ("CheckSimplicity", visitCilFileSameGlobals new visitor)
