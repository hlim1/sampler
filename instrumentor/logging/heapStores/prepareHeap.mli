open Cil


class visitor : file ->
  object
    inherit Manager.visitor

    method private findSites : fundec -> stmt list * global list
  end
