open Cil
open Classify


let shouldTransform func =
  match classifyByName func.svar.vname with
  | Check | Fail | Init ->
      false
  | Generic ->
      ShouldTransform.shouldTransform func
