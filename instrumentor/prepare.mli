open Cil


type info = {
    stmts : StmtSet.container;
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

    method private prepare : fundec -> global list * info

    method finalize : file -> unit
  end
