open Cil


let main () =
  initCIL ();

  let scanFile filename =

    let file = Frontc.parse filename () in

    let scanGlobal = function
      | GFun (func, _)
	when Should.shouldTransform func ->
	  prepareCFG func;
	  IsolateInstructions.visit func;
	  let collector = new Find.visitor in
	  ignore (visitCilFunction (collector :> cilVisitor) func);
	  begin
	    match collector#sites with
	    | [] -> ()
	    | _ -> print_endline func.svar.vname
	  end
      | _ ->
	  ()
    in
    iterGlobals file scanGlobal
  in
  let filenames = List.tl (Array.to_list Sys.argv) in
  List.iter scanFile filenames

;;

main ()
