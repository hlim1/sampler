open Cil


type collection = unit Int64Hash.c


let compareToConstants =
  Options.registerBoolean
    ~flag:"compare-constants"
    ~desc:"compare with constant expressions found in same file"
    ~ident:"CompareConstants"
    ~default:false


class visitor collection =
  object
    inherit nopCilVisitor

    method vexpr exp =
      begin
	match isInteger (constFold true exp) with
	| Some constant ->
	    if not (collection#mem constant) then
	      collection#add constant ()
	| None ->
	    ()
      end;
      DoChildren
  end


let collect file =
  let collection = new Int64Hash.c 1 in
  collection#add Int64.zero ();
  if !compareToConstants then
    begin
      let visitor = new visitor collection in
      visitCilFileSameGlobals visitor file
    end;
  collection
