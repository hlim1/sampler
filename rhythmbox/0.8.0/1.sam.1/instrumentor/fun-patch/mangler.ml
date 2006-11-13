open Cil


let mangle file = function
  | GVar (varinfo, _, _)
  | GFun ({svar = varinfo}, _)
    when varinfo.vstorage == Static ->
      let suffix = Hashtbl.hash (file, varinfo) in
      varinfo.vname <- varinfo.vname
	^ "$static$"
	^ Printf.sprintf "%x" suffix;
      varinfo.vstorage <- NoStorage
  | _ ->
      ()


let phase =
  "Mangle",
  fun file ->
    iterGlobals file (mangle file)
