open Cil


class visitor :
  object
    inherit Prepare.visitor
    method private collectSites : fundec -> Sites.info
  end
