class visitor file =
  let tuples = new PairTuples.builder file in
  let constants = Constants.collect file in

  object
    inherit Manager.visitor file as super

    val classifier = new PairClassifier.visitor file constants tuples

    method private statementClassifier = classifier

    method private finalize =
      tuples#finalize;
      super#finalize
  end
