open Cil


class visitor : file ->
  object
    inherit Manager.visitor

    method private statementClassifier : global -> fundec -> Classifier.visitor
  end
