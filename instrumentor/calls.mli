open Cil


type info = {
    export : stmt;
    call : stmt;
    callee : exp;
    import : stmt;
    jump : stmt;
    landing : stmt;
    site : stmt;
  }

type infos = info list


val prepatch : stmt -> info
