open Cil
open Printf


let checkLvalue = function
  | (Mem Lval (Var _, NoOffset), NoOffset) -> ()
  | (Var _, _) -> ()
  | other -> ignore(warnContext "complex lvalue: %a" d_lval other)
	
	
class visitor = object
  inherit nopCilVisitor

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
		  | other -> ignore(warnContext "complex rvalue: %a" d_exp other)
		end
	    | _ -> ()
	  end
      | Call (Some lval, _, _, _) ->
	  checkLvalue lval
      | _ -> ()
    end;
    
    SkipChildren
end
