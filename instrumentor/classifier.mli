open Cil


class visitor :
  object
    inherit FunctionBodyVisitor.visitor

    method private includedFunction : fundec -> bool
    method private includedStatement : stmt -> bool

    method private prepatchCall : stmt -> Calls.info

    method calls : Calls.infos
    method sites : stmt list
  end
