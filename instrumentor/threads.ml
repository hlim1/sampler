open Cil


let threads =
  Options.registerBoolean
    ~flag:"threads"
    ~desc:"create thread-safe code"
    ~ident:"Threads"
    ~default:false


let bump file =
  if !threads then
    let bumper = Lval (var (FindFunction.find "atomicIncrementCounter" file)) in
    fun counter location ->
      Call (None, bumper, [mkAddrOf counter], location)
  else
    fun counter location ->
      Set (counter, increm (Lval counter) 1, location)
