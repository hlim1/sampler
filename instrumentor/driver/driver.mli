open Unix


class virtual c : string list ->
  object
    val mutable verbose : bool

    method private parse : unit
    method private virtual parse_1 : string -> string list -> string list

    method private virtual build : unit

    method private trace : CommandLine.t -> unit
    method private run : CommandLine.t -> unit
    method private runOut : CommandLine.t -> Unix.file_descr -> unit
  end
