open Cil
open Pretty
open Errormsg
open Reachingdefs

class myGoofyVisitor : cilVisitor = object
  inherit nopCilVisitor

  method vfunc (f : fundec) : fundec visitAction = 
    computeRDs f;
    fprint stdout 80 (ppFdec f); 
    SkipChildren

end

let process filename =
  let file = Frontc.parse filename () in
  let _ = Maincil.makeCFGFeature.C.fd_doit file in
  let mgVisitor = new myGoofyVisitor in
  visitCilFile mgVisitor file

;;

initCIL ();
let filenames = List.tl (Array.to_list Sys.argv) 
in 
List.iter process filenames 
;;
