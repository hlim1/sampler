class visitor file =
  object
    inherit PrepareDaikount.visitor file
	
    val collectSites = Collector.collect file
    method private collectSites = collectSites
  end
