open Unix


class virtual c : string list ->
  object
    val mutable verbose : bool

    method private parse : string list -> unit
    method private virtual parse_1 : string -> string list -> string list

    method private virtual build : unit

    method private trace : string -> string list -> unit
    method private run : string -> string list -> unit
    method private runOut : string -> string list -> Unix.file_descr -> unit
  end
