class c : string -> string list ->
  object
    inherit Driver.c

    val saveTemps : bool
    val flags : string list
    val mutable finalFlags : string list

    method private extraLibs : string list

    method private parse_1 : string -> string list -> string list
    method private build : unit

    method private prepare : string -> string
  end
