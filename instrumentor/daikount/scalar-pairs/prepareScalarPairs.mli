open Cil


class visitor : file ->
  object
    inherit PrepareDaikount.visitor
    method private collectSites : fundec -> Sites.info
  end
