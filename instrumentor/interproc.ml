open Cil


let sample = ref true

let _ =
  Options.registerBoolean
    sample
    ~flag:"sample"
    ~desc:"randomly sample instrumentation sites at run time"
    ~ident:"Sample"


let visit preparator file =
  let visitor = preparator file in
  visitCilFile (visitor :> cilVisitor) file;
  if !sample then
    begin
      let infos = visitor#infos in
      let tester = Weightless.collect infos in
      let countdown = new Countdown.countdown file in
      infos#iter (Transform.visit tester countdown)
    end;
  visitor#finalize file
