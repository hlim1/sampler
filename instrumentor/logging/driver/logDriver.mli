class c : string -> string -> string -> string list ->
  object
    inherit InstDriver.c

    method private extraHeader : string
    method private extraLibs : string list
  end
