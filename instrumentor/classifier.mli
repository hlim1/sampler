open Cil


class visitor : global ->
  object
    inherit FunctionBodyVisitor.visitor

    method private prepatchCall : stmt -> Calls.info
    method private addGlobal : global -> unit

    method calls : Calls.infos
    method sites : stmt list
    method globals : global list
  end
