open Cil


type globalCountdown = lval


let findGlobal =
  let predicate = function
    | {vname = "nextLogCountdown"; vtype = TInt _} -> true
    | _ -> false
  in
  FindGlobal.find predicate


class countdown global fundec =
  let local = var (makeTempVar fundec ~name:"localCountdown" uintType) in
  
  object (self)
    method decrement location =
      Set (local, increm (Lval local) (-1), location)

    method beforeCall location =
      Set (global, (Lval local), location)

    method afterCall location =
      Set (local, (Lval global), location)

    method choose location weight instrumented original =
      let within = kinteger IUInt weight in
      let predicate = BinOp (Gt, Lval local, within, intType) in
      let choice = If (predicate, original, instrumented, location) in
      (* Choices.add choice; *)
      choice
  end
