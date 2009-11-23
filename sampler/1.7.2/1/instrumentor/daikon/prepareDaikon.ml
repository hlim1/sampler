class visitor file =
  let collector = new Collector.visitor file in

  object
    inherit Manager.visitor "daikon" file

    method private statementClassifier = collector
  end
