open Cil
open Classify


class visitor =
  object
    inherit Prepare.visitor

    method private collectSites = Find.collect
    method private prepatcher = new DecureCalls.prepatcher
    method private shouldTransform = Should.shouldTransform
  end
