open Cil


class type filter =
  object
    inherit [location] Clude.filter

    method private matches : location -> location -> bool
    method private format : location -> Pretty.doc
  end


val filter : filter
