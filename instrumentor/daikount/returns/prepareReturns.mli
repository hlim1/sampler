open Cil


class visitor : file ->
  object
    inherit PrepareDaikount.visitor

    method private collectSites : fundec -> Sites.info
    method private prepare : fundec -> global list * Prepare.info
  end
