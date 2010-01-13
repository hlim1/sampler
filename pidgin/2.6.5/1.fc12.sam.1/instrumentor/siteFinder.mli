open Cil


class visitor :
  object
    inherit FunctionBodyVisitor.visitor

    method private includedFile : string -> bool
    method private includedFunction : fundec -> bool
    method private includedStatement : stmt -> bool
  end
