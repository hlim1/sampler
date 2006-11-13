class visitor file =
  let tuples = new ReturnTuples.builder file in

  object
    inherit Manager.visitor file as super
	
    val classifier = new ReturnClassifier.visitor tuples

    method private statementClassifier = classifier

    method private finalize =
      tuples#finalize;
      super#finalize
  end
