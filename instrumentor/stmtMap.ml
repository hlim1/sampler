open Cil


module StmtMap = MapClass.Make (StmtHash)

class ['data] container = ['data] StmtMap.container
