open Cil
open Classify


class prepatcher =
  object
    inherit Calls.prepatcher as super

    method vstmt stmt =
      match classifyStatement stmt.skind with
      | Check
      | Fail ->
	  SkipChildren
      | Generic ->
	  super#vstmt stmt
  end
