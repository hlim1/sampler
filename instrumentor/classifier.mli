open Cil


class visitor : global ->
  object
    inherit FunctionBodyVisitor.visitor

    method private prepatchCall : stmt -> Calls.info

    method calls : Calls.infos
    method sites : stmt list
    method globals : GlobalQueue.container
  end
