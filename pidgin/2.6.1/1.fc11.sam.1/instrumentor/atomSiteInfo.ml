open Cil
open Pretty


type access = Read | Write


let accessName = function
  | Read -> "read"
  | Write -> "write"


class c func inspiration (lval : lval) access =
  object
    inherit SiteInfo.c func inspiration as super

    method print =
      let lval_expr = Lval lval in
      let prevStyle = !lineDirectiveStyle in
      lineDirectiveStyle := None;
      let result = super#print @
	[dd_exp () lval_expr;
	 text (accessName access)]
      in
      lineDirectiveStyle := prevStyle;
      result
  end
