class visitor file =
  object
    inherit PrepareDaikount.visitor file as super
	
    val collectSites = Collector.collect file
    method private collectSites = collectSites

    method private prepare func =
      StoreReturns.visit func;
      super#prepare func
  end
