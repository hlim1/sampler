open Cil


class visitor : fundec ->
  object
    inherit FunctionBodyVisitor.visitor

    val mutable sites : stmt list
    method sites : stmt list
    method calls : Calls.infos

    val includedFunction : bool
    method private shouldVisit : bool

    method private normalize : unit
    method private includedStatement : stmt -> bool
    method private prepatchCall : stmt -> Calls.info
  end
