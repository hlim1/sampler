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


let prepatch {sbody = sbody} =
  let visitor = new prepatcher in
  ignore (visitCilBlock (visitor :> cilVisitor) sbody);
  visitor#result
