open Cil
open Classify


class visitor file =
  object
    inherit Manager.visitor file as super

    method private statementClassifier = new Collector.visitor
  end
