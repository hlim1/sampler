open Cil


type t = fundec

let equal a b = VariableNameHash.equal a.svar b.svar

let hash {svar = svar} =
  VariableNameHash.hash svar
