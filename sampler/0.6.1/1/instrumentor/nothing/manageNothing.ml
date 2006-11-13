open Cil


class visitor file =
  object
    inherit Manager.visitor "nothing" file

    method private statementClassifier = new Classifier.visitor
  end
