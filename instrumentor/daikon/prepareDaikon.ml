class visitor file =
  object
    inherit Prepare.visitor

    val collectSites = Collector.collect file
    method private collectSites = collectSites
  end
