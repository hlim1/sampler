open Cil


class visitor : file ->
  object
    inherit Prepare.visitor

    method private collectSites : fundec -> Sites.info
  end
