class c : string -> CommandLine.t -> CommandLine.t ->
  object
    inherit InstDriver.c

    method private extraHeader : string
    method private extraLibs : string list
  end
