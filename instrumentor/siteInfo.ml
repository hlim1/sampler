open Cil
open Pretty


class c func inspiration =
  object (self)
    val implementation = mkEmptyStmt ()

    method fundec = func
    method inspiration : location = inspiration
    method implementation = implementation

    method print =
      let location = get_stmtLoc implementation.skind in
      [text location.file;
       num location.line;
       text func.svar.vname;
       num implementation.sid]
  end
