open Cil
open Calls


let nextLabelNum = ref 0

let label name = Label (name, locUnknown, false)

let nextLabels _ =
  incr nextLabelNum;
  let basis = "postCall" ^ string_of_int !nextLabelNum in
  label basis, label (basis ^ "__dup")


let patch clones weights countdown =
  let patchOne standard =
    let findClone = ClonesMap.findCloneOf clones in
    let instrumentedImport = findClone standard.import in
    let instrumentedJump = findClone standard.jump in
    let instrumentedLanding = findClone standard.landing in

    let export () = Instr [countdown#export] in
    let instrumentedExport = findClone standard.export in
    standard.export.skind <- export ();
    instrumentedExport.skind <- export ();

    let import () = Instr [countdown#import] in
    standard.import.skind <- import ();
    instrumentedImport.skind <- import ();

    let weight = weights#find standard.landing in
    let choice () = countdown#checkThreshold locUnknown weight instrumentedLanding standard.landing in
    standard.jump.skind <- choice ();
    instrumentedJump.skind <- choice ();

    let standardLabel, instrumentedLabel = nextLabels () in
    standard.landing.labels <- [standardLabel];
    instrumentedLanding.labels <- [instrumentedLabel]
  in
  
  List.iter patchOne
