open Cil
open Classify


class visitor file =
  object
    inherit Manager.visitor file as super

    method private shouldTransform func =
      super#shouldTransform func && Should.shouldTransform func

    method private statementClassifier = new Collector.visitor
  end
