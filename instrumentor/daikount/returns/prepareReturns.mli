open Cil


class visitor : file ->
  object
    inherit PrepareDaikount.visitor

    method private statementClassifier : fundec -> Classifier.visitor
    method private normalize : fundec -> unit
  end
