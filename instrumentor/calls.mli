open Cil


type info = {
    export : stmt;
    callee : exp;
    import : stmt;
    jump : stmt;
    landing : stmt;
  }

type infos = info list


class prepatcher : object
  inherit cilVisitor
  method result : infos
end


val prepatch : prepatcher -> fundec -> infos
