let name = "nothing"


class c file =
  object
    inherit Scheme.c name file

    method findAllSites = ()
    method private findSites = ignore
    method embedInfo = ignore
  end


let factory = new c
