let name = "nothing"


class c file =
  object
    inherit Scheme.c file

    method private findSites = ignore
    method embedInfo = ignore
  end


let register () = Schemes.register name new c
