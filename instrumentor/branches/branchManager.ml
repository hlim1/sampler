open Cil


class visitor file =
  let counters = new Counters.builder file in
  let classifier = new BranchClassifier.visitor counters in

  object
    inherit Manager.visitor file as super

    method private statementClassifier = classifier

    method private finalize =
      counters#register;
      super#finalize
  end
