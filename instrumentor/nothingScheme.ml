open SchemeName


let name = {
  flag = "nothing";
  prefix = "nothing";
  ident = "Nothing";
}


class c file =
  object
    inherit Scheme.c name file

    method findAllSites = ()
    method private findSites = ignore
    method saveSiteInfo _ = ignore
  end


let factory = new c
