open Cil


class visitor : file ->
  object
    inherit Manager.visitor

    method private statementClassifier : fundec -> Classifier.visitor
  end
