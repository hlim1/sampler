open Cil


let threads =
  Options.registerBoolean
    ~flag:"threads"
    ~desc:"create thread-safe code"
    ~ident:"Threads"
    ~default:false
