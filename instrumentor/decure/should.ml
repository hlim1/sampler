open Cil
open Classify


let shouldTransform func =
  match classifyByName func.svar.vname with
  | Check
  | Fail ->
      false
  | Generic ->
      ShouldTransform.shouldTransform func
