class visitor file =
  let tuples = new PairTuples.builder file in
  let constants = Constants.collect file in

  object
    inherit Manager.visitor "scalar-pairs" file as super

    val classifier = new PairClassifier.visitor file constants tuples

    method private statementClassifier = classifier

    method private finalize digest =
      tuples#finalize digest;
      super#finalize digest
  end
