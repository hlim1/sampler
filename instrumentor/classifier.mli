open Cil


class visitor :
  object
    inherit FunctionBodyVisitor.visitor

    method private prepatchCall : stmt -> Calls.info

    method calls : Calls.infos
    method sites : stmt list
  end
