open Cil
open Classify


class visitor file =
  object
    inherit Manager.visitor "decure" file as super

    method private statementClassifier = new Collector.visitor
  end
