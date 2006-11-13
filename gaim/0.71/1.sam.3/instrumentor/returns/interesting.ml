open Cil


let isInterestingType resultType =
  match unrollType resultType with
  | TInt _
  | TEnum _
  | TPtr _ ->
      true
  | _ ->
      false
