open Cil


class visitor file =
  object
    inherit Manager.visitor file

    method private statementClassifier global _ = new Classifier.visitor global
  end
