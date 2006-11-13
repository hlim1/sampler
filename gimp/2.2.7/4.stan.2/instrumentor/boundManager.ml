open Cil
open FindFunction
open Printf


let globals = new StackClass.container
let infos = new QueueClass.container


let register vars info =
  globals#push vars;
  infos#push info


let patch file =
  let findDecl target = find target file in
  let findDefn target = findDefinition target file in

  let dumpSignedChar = findDecl "boundDumpSignedChar" in
  let dumpUnsignedChar = findDecl "boundDumpUnsignedChar" in
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
    globals#iter
      (fun (min, max) ->
	let dumper = match min.vtype with
	| TInt (IChar, _) ->
	    if !char_is_unsigned then
	      dumpUnsignedChar
	    else
	      dumpSignedChar
	| TInt (ISChar, _) -> dumpSignedChar
	| TInt (IUChar, _) -> dumpUnsignedChar
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
				       locUnknown)) :: !calls);
    mkBlock !calls
  in

  let dumper = emptyFunction "boundsReportDump" in
  dumper.sbody <- calls;
  dumper.svar <- findDecl dumper.svar.vname;
  file.globals <- file.globals @ [GFun (dumper, locUnknown)];

  let boundsReporter = findDecl "boundsReporter" in
  let reporter = findDefn "samplerReporter" in
  let call = Call (None, Lval (var boundsReporter), [], locUnknown) in
  reporter.sbody.bstmts <- mkStmtOneInstr call :: reporter.sbody.bstmts


let saveSiteInfo scheme digest channel =
  SiteInfo.print channel digest scheme infos
