class visitor file =
  object
    inherit Prepare.visitor as super

    val collectSites = Collector.collect file
    method private collectSites = collectSites

    method finalize file =
      Invariant.register file
  end
