open Cil


let sample = ref true

let _ =
  Options.registerBoolean
    sample
    ~flag:"sample"
    ~desc:"randomly sample instrumentation sites at run time"
    ~ident:"sample"


let visit preparator file =
  let visitor = preparator file in
  visitCilFile (visitor :> cilVisitor) file;
  if !sample then
    let infos = visitor#infos in
    let tester = Weightless.collect infos in
    let countdown = Countdown.find file in
    infos#iter (Transform.visit tester countdown)
