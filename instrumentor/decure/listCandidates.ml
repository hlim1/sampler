open Cil


let error = ref false


let main () =
  initCIL ();

  let scanFile filename =
    try
      let file = Frontc.parse filename () in

      let scanGlobal = function
	| GFun (func, _) as global
	  when Should.shouldTransform func ->
	    begin
	      prepareCFG func;
	      IsolateInstructions.visit func;
	      let collector = new Collector.visitor global func in
	      ignore (visitCilFunction (collector :> cilVisitor) func);
	      if collector#sites != [] then
		print_endline func.svar.vname
	    end
	| _ ->
	    ()
      in
      iterGlobals file scanGlobal
    with Frontc.ParseError _ ->
      error := true
  in
  let filenames = List.tl (Array.to_list Sys.argv) in
  List.iter scanFile filenames;
  if !error then exit 1
      

;;

main ()
