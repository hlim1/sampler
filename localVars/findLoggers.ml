open Cil
open Loggers


let find file =
  let hash = Hashtbl.create 13 in
  
  let add = function
    | GVarDecl ({vname = vname; vtype = TFun _} as varinfo, _) ->
	Hashtbl.add hash vname varinfo
    | _ -> ()
  in
  
  List.iter add file.globals;

  let find name =
    Lval (var (Hashtbl.find hash name))
  in
  
  {
   pointer = find "logPointer";

   double = find "logDouble";
   longDouble = find "logLongDouble";

   char = find "logChar";

   short = find "logShort";
   unsignedShort = find "logUnsignedShort";

   int = find "logInt";
   unsignedInt = find "logUnsignedInt";

   long = find "logLong";
   unsignedLong = find "logUnsignedLong";

   longLong = find "logLongLong";
   unsignedLongLong = find "logUnsignedLongLong";
 }
