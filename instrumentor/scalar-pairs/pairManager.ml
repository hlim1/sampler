class visitor file =
  let tuples = new PairTuples.builder file in

  object
    inherit Manager.visitor file as super

    val classifier = new PairClassifier.visitor file tuples

    method private statementClassifier = classifier

    method private finalize =
      tuples#finalize;
      super#finalize
  end
