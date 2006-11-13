open Cil


class virtual visitor : file ->
  object
    method private virtual statementClassifier : fundec -> Classifier.visitor
    method private finalize : unit
  end
