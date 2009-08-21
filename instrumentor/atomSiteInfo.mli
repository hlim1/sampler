open Cil


type access = Read | Write

class c : fundec -> location -> lval -> access -> SiteInfo.c
