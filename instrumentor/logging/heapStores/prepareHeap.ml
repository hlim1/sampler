class visitor file =
  let collector = new Log.visitor file in

  object
    inherit Manager.visitor file

    method private statementClassifier _ = collector ()
  end
