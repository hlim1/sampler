open Cil
  

type clonesMap = stmt StmtMap.container

val duplicateBody : fundec -> block * block * clonesMap
