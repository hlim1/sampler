class virtual c : string -> string -> string -> string list ->
  object
    inherit GccDriver.c

    method private virtual extraHeader : string
    method private extraLibs : string list

    method private runCpp : string -> string list -> string
    method private prepareInstrument : string -> string
  end
