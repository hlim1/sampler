open Cil


class visitor file =
  object
    inherit Manager.visitor file

    method private statementClassifier _ = new Classifier.visitor
  end
