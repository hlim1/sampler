open Cil
open Calls


let patch clones weights countdown =
  let patchOne standard =
    let findClone = ClonesMap.findCloneOf clones in
    let instrumentedImport = findClone standard.import in
    let instrumentedJump = findClone standard.jump in
    let instrumentedLanding = findClone standard.landing in

    let export () = Instr [countdown#export locUnknown] in
    let instrumentedExport = findClone standard.export in
    standard.export.skind <- export ();
    instrumentedExport.skind <- export ();

    let import () = Instr [countdown#import locUnknown] in
    standard.import.skind <- import ();
    instrumentedImport.skind <- import ();

    let weight = weights#find standard.landing in
    let choice () = countdown#checkThreshold locUnknown weight instrumentedLanding standard.landing in
    standard.jump.skind <- choice ();
    instrumentedJump.skind <- choice ()
  in
  
  List.iter patchOne
