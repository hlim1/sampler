open Cil
open Printf


let visit func =

  let subphases : (string * cilVisitor) list = [
    "SimplifyReturns", new SimplifyReturns.visitor;
    "SimplifyLefts", new SimplifyLefts.visitor;
    "SimplifyRights", new SimplifyRights.visitor;
    "CheckSimplicity", new CheckSimplicity.visitor;
  ] in
      
  let doSubphase (title, visitor) =
    ignore (Cil.visitCilFunction visitor func);
  in
  
  List.iter doSubphase subphases
