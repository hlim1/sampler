open Cil


let build elements =

  let slot = ref 0 in

  let transform element =
    let offset = Index (integer !slot, NoOffset) in
    incr slot;
    (offset, element)
  in

  List.map transform elements
