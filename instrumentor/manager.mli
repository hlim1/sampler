open Cil


class virtual visitor : file ->
  object
    method private shouldTransform : fundec -> bool
    method private virtual statementClassifier : fundec -> Classifier.visitor

    method private normalize : fundec -> unit
    method private finalize : unit

    method visit : unit
  end
