open Cil


type bumper = Tuples.siteId -> exp -> location -> instr


let build file =
  if !Threads.threads then
    let incrementor = Lval (var (FindFunction.find "atomicIncrementCounter" file)) in
    fun site slot location ->
      Call (None, incrementor, [integer site; slot], location)
  else
    let counterTuples = FindGlobal.find "counterTuples" file in
    fun site slot location ->
      let counter : lval = (Var counterTuples, Index (integer site, Index (slot, NoOffset))) in
      Set (counter, increm (Lval counter) 1, location)
