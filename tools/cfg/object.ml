open Basics


type result = Compilation.result list


let parse name =
    let compilations = sequence Stream.empty (Compilation.parse name) in
    parser [< compilations = compilations >] -> compilations


let addNodes =
  List.iter Compilation.addNodes


let addEdges =
  List.iter Compilation.addEdges
