open Cil


class visitor :
  object
    inherit FunctionBodyVisitor.visitor

    method private includedLocation : location -> bool
    method private includedFunction : fundec -> bool
    method private includedStatement : stmt -> bool
  end
