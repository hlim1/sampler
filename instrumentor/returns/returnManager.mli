open Cil


class visitor : file ->
  object
    inherit Manager.visitor

    method private statementClassifier : global -> fundec -> Classifier.visitor
    method private normalize : fundec -> unit
  end
