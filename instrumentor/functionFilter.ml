open Cil
open Clude


let filter = new Clude.filter
    ~flag:"function"
    ~desc:"<function> instrument this function"
    ~ident:"FilterFunction"


let collectPragmas file =
  let iterator = function
    | GPragma (Attr ("sampler_exclude_function", [AStr name]), _) ->
	filter#addExclude name
    | _ -> ()
  in
  iterGlobals file iterator
