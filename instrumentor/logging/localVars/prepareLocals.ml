class visitor file =
  let collector = Log.collect file in

  object
    inherit Manager.visitor file

    method private findSites = collector
  end
