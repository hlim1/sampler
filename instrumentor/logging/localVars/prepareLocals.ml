class visitor file =
  object
    inherit Prepare.visitor

    method private collectSites = Log.collect file
  end
