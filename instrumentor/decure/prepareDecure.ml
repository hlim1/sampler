open Cil
open Classify


class visitor =
  object
    inherit Prepare.visitor

    method private collectSites = Find.collect
    method private prepatchCalls = DecureCalls.prepatch
    method private shouldTransform = Should.shouldTransform
  end
