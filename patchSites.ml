open Cil
  
  
type patchSites = Cil.stmt ref list


let patch clones =
  let patchOne dest = dest := clones#find !dest in
  List.iter patchOne
