open Cil


class virtual visitor : string -> file ->
  object
    method private virtual statementClassifier : fundec -> Classifier.visitor
    method private finalize : unit
  end
