open Cil


type info = {
    sites : StmtSet.container;
    calls : Calls.infos;
  }


class infos : [info] FunctionMap.container


class virtual visitor :
  object
    inherit SkipVisitor.visitor

    method infos : infos

    method private virtual collectSites : fundec -> Sites.info
    method private prepatcher : Calls.prepatcher
    method private shouldTransform : fundec -> bool

    method finalize : file -> unit
  end
