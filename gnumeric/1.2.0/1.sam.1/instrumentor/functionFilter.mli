open Cil


class filter : flag:string -> desc:string -> ident:string ->
  object
    inherit Clude.filter

    method collectPragmas : file -> unit
  end


val filter : filter
