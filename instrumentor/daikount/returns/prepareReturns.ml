class visitor file =
  let collector = new Collector.visitor file in

  object
    inherit PrepareDaikount.visitor file as super
	
    method private statementClassifier = collector

    method private normalize func =
      StoreReturns.visit func;
      super#normalize func
  end
