open Cil


let build address data location =
  Call (None, Lval (var LogWrite.logWrite),
	[mkCast (mkString location.file) charConstPtrType;
	 kinteger IUInt location.line;
	 mkCast address LogWrite.voidConstPtrType;
	 SizeOf(typeOfLval data);
	 mkCast (mkAddrOf data) LogWrite.voidConstPtrType],
	location)
