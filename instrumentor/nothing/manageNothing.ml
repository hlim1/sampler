open Cil


class visitor file =
  object
    inherit Manager.visitor file

    method private statementClassifier = new Classifier.visitor
  end
