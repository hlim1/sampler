open Cil
open Clude
open Scanf
open Scanning

let resetAtPoints =
  Options.registerString
    ~flag:"reset-at-points"
    ~desc:"reset counters when the first location in the named file is executed"
    ~ident:"resetAtPoints"

let readResetPoints ptsFile =
  let points = new HashClass.c 1 in
  if ptsFile <> "" then
    let scanbuf = from_file ptsFile in
    while not (end_of_input scanbuf) do
      bscanf scanbuf "%s %d\n"
      (fun file line ->
      if not (points#mem file) then
        points#add file (Inthash.create 1);
      Inthash.add (points#find file) line 1;
    )
    done;
  points
  else
  points

class visitor file points =
  object
    inherit FunctionBodyVisitor.visitor

    val callStmt =
      let zeroSetter = FindFunction.find ("cbi_guardedSetZero") file in
      mkStmtOneInstr (Call (None, Lval (var zeroSetter), [], locUnknown))

  method vstmt stmt =
    let loc = get_stmtLoc stmt.skind in
    if points#mem loc.file then
      let resetLines = points#find loc.file in
      if Inthash.mem resetLines loc.line then
        let replacement = mkStmt stmt.skind in
        stmt.skind <- Block (mkBlock [callStmt; replacement]);
        SkipChildren
      else
        DoChildren
    else
      DoChildren
  end

let visit file =
  let points = readResetPoints !resetAtPoints in
  if !resetAtPoints <> "" then
    let visitor = new visitor file points in
    ignore(visitCilFileSameGlobals (visitor :> cilVisitor) file)
  else
    ()
