open Cil


class type filter =
  object
    inherit [string] Clude.filter

    method collectPragmas : file -> unit
    method private matches : string -> string -> bool
    method private format : string -> Pretty.doc
  end


val filter : filter


val instrumentable : fundec -> bool
