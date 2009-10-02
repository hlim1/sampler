open Cil
open Ptranal
open Dynamic
(* cci *)


let is_bitfield lval =
  let (_, offset) = lval in
  match offset with
    Field(finfo,_) -> (finfo.fname = Cil.missingFieldName) || (match finfo.fbitfield with Some(_) -> true | _-> false)
  
  | _-> false 


let scrub_filename str =
  let new_str = ref "" in
  String.iter 
    (fun c -> match c 
    with 
      '.'| '/' | ':' -> new_str:= !new_str^"_" 
    | _-> new_str := !new_str^(String.make 1 c) ) str;
  !new_str
  

let get_prefix_file file =
  ("cbi_"^scrub_filename(file.fileName))


let findOrCreate_local func vname = 
  try 
  List.find ( fun vi -> vi.vname = vname) func.slocals 
  with Not_found -> 
    makeLocalVar func vname intType

let findOrCreate_local_type func vname typ = 
  try 
  List.find ( fun vi -> vi.vname = vname) func.slocals 
  with Not_found -> 
    makeLocalVar func vname typ


let create_global file vname =
    let b_varinfo = makeGlobalVar vname intType in
    let global  = GVar(b_varinfo, {init = Some (SingleInit zero)}, locUnknown) in 
    file.globals <- global ::file.globals;
    b_varinfo

let findOrCreate_global file vname = 
  try 
    match(List.find 
	    ( fun g -> match g with GVar(vi,_,_) -> vi.vname = vname  (*TODO check with GVarDecl too?*)
	    | _-> false)
	    file.globals) with
    | GVar(vi,_,_) -> vi 
    | _ -> create_global file vname
  with Not_found ->  (*create global variable*)
    create_global file vname

let getExp vinfo :exp = Lval(var vinfo)
