open Cil
open FindFunction


let registry = new StackClass.container


let register min max doc =
  registry#push (min, max, doc)


let patch file =
  let findDecl target = find target file in
  let findDefn target = findDefinition target file in

  let dumpChar = findDecl "boundDumpChar" in
  let dumpSignedShort = findDecl "boundDumpSignedShort" in
  let dumpUnsignedShort = findDecl "boundDumpUnsignedShort" in
  let dumpSignedInt = findDecl "boundDumpSignedInt" in
  let dumpUnsignedInt = findDecl "boundDumpUnsignedInt" in
  let dumpSignedLong = findDecl "boundDumpSignedLong" in
  let dumpUnsignedLong = findDecl "boundDumpUnsignedLong" in
  let dumpSignedLongLong = findDecl "boundDumpSignedLongLong" in
  let dumpUnsignedLongLong = findDecl "boundDumpUnsignedLongLong" in
  let dumpPointer = findDecl "boundDumpPointer" in

  let calls =
    let calls = ref [] in
    let builder (min, max, _) =
      let dumper = match min.vtype with
      | TInt (IChar, _)
      | TInt (ISChar, _)
      | TInt (IUChar, _) -> dumpChar
      | TInt (IShort, _) -> dumpSignedShort
      | TInt (IUShort, _) -> dumpUnsignedShort
      | TInt (IInt, _) -> dumpSignedInt
      | TInt (IUInt, _) -> dumpUnsignedInt
      | TInt (ILong, _) -> dumpSignedLong
      | TInt (IULong, _) -> dumpUnsignedLong
      | TInt (ILongLong, _) -> dumpSignedLongLong
      | TInt (IULongLong, _) -> dumpUnsignedLongLong
      | TPtr _ -> dumpPointer
      | TEnum _ -> dumpSignedInt
      | other ->
	  ignore (bug "don't know how to dump bounds of type %a\n" d_type other);
	  failwith "internal error"
      in
      calls := mkStmtOneInstr (Call (None, Lval (var dumper), [Lval (var min);
							       Lval (var max)],
				     locUnknown)) :: !calls
    in
    registry#iter builder;
    mkBlock !calls
  in

  let dumper = emptyFunction "boundsReportDump" in
  dumper.sbody <- calls;
  file.globals <- file.globals @ [GFun (dumper, locUnknown)];

  let boundsReporter = findDecl "boundsReporter" in
  let reporter = findDefn "samplerReporter" in
  let call = Call (None, Lval (var boundsReporter), [], locUnknown) in
  reporter.sbody.bstmts <- mkStmtOneInstr call :: reporter.sbody.bstmts
