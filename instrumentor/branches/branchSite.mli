open Cil


class c : stmt -> (exp * block * block * location) ->
  object
    inherit Site.c

    method enact : stmt
  end


val embedInfo : file -> unit
