open Cil


class visitor file =
  let classifier = new BranchClassifier.visitor file in

  object
    inherit Manager.visitor file as super

    method private statementClassifier = classifier

    method private finalize =
      Counters.register file;
      super#finalize
  end
