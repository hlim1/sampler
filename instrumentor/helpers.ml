open Cil
open Ptranal
open Dynamic
(* cci *)


let is_bitfield lval =
  let (_, offset) = lval in
  match offset with
    Field(finfo,_) -> (finfo.fname = Cil.missingFieldName) || (match finfo.fbitfield with Some(_) -> true | _-> false)
  
  | _-> false 

let is_register lval =
  let (lh,_) = lval in
  match lh with Var vi -> vi.vstorage == Register
  |_-> false 


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


let get_prefix func file =
  ("cbi_"^scrub_filename(file.fileName)^"_"^(func.svar.vname))

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


let aliasGlobal file lv : bool =
  let isA = ref false in
  List.iter(fun g ->
    match g 
    with GVar(vi,_,_) 
    | GVarDecl(vi,_) -> isA:=!isA || (try may_alias (getExp vi) (Lval(lv)) with Not_found -> false) 
    | GFun(func,_) -> isA :=!isA || (try may_alias (getExp (func.svar)) (Lval(lv)) with Not_found -> false) 
    |  _-> () ) file.globals; 
  !isA

let rec isGlobalLval file lv : bool = 
  let lhost,_ = lv in
  match lhost with
    Var varinfo -> varinfo.vglob   || varinfo.vname = "buf"    (*hack hack !!! *)
  | Mem exp -> hasGlobal file exp
and ptsToGlobal lv : bool = 
  try 
  let res = resolve_lval lv in
  let isG = ref false in
  List.iter( fun vi -> isG := !isG || vi.vglob ) res;
  !isG
    with Not_found -> false (* conservative ? *)
and  hasGlobal file expr : bool = 
  match expr with
    Const _-> false
  | Lval lv -> isInterestingLval file lv || exp_ptsToGlobal expr 
  | UnOp(_ , expr1, _)-> hasGlobal file expr1 
  | BinOp(_, expr1, expr2, _) -> hasGlobal file expr1 || hasGlobal file expr2 
  | AddrOf lv -> exp_ptsToGlobal expr || isInterestingLval file lv 
  | StartOf lv -> exp_ptsToGlobal expr || isInterestingLval file lv
  | CastE (_, expr) -> hasGlobal file expr
  | _-> false 
and exp_ptsToGlobal expr : bool =
  try 
    let res = resolve_exp expr in
    let isG = ref false in
    List.iter (fun vi -> isG := !isG || vi.vglob) res;
    !isG 
      with Not_found -> false
(*  returns true if the lval is a global, pts-to a a global or aliases with one*)
and isInterestingLval file lv : bool = 
  isGlobalLval file lv || ptsToGlobal lv || aliasGlobal file lv


(*return true if the expr contains a global*)
let isInterestingExp file expr : bool = 
(*   visitExp (isInterestingLval file ) expr *)
  hasGlobal file expr





