open Cil


let bump file =
  let bumper = Bumper.build file in
  fun site location expression ->
    let bnot exp = UnOp (LNot, exp, typeOf exp) in
    let slot = bnot (bnot expression) in

    Instr [bumper site slot location]
