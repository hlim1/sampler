open Printf


let visit func block =

  let subphases = [
    "SimplifyReturns", new SimplifyReturns.visitor;
    "SimplifyLefts", new SimplifyLefts.visitor;
    "SimplifyRights", new SimplifyRights.visitor;
    "CheckSimplicity", (fun _ -> new CheckSimplicity.visitor);
    "Instrument", (fun _ -> new Instrument.visitor)
  ] in
      
  let doSubphase (title, visitor) =
    eprintf "  subphase %s begins\n" title;
    let replacement = Cil.visitCilBlock (visitor func) block in
    if replacement != block then
      failwith "subphase unexpectedly offered replacement block";
    eprintf "  subphase %s ends\n" title
  in
  
  List.iter doSubphase subphases
