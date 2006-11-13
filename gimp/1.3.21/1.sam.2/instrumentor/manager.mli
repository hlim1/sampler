open Cil


class virtual visitor : string -> file ->
  object
    method private virtual statementClassifier : fundec -> Classifier.visitor
    method private finalize : Digest.t Lazy.t -> unit
  end
