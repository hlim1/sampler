open Cil
open Pretty

let debug = ref true

module E = Errormsg
module IH = Inthash
module DF = Dataflow
module UD = Usedef

let _ = UD.considerVariableUse := (fun _ -> false) 
let _ = UD.considerVariableAddrOfAsUse := (fun _ -> false) 

module Upward (* : DF.ForwardsTransfer *) =
  struct
    let name = "MustBeUninitialized"

    let debug = ref false 

    type t = bool IH.t 

    let copy var_table = IH.copy var_table 

    let stmtStartData = IH.create 32

    let pretty () data =
      let pretty_var vid init =
        text "variable id: " ++ num vid ++ text " initialized? " ++ 
        text (if init then "Yes" else "No") in
      line ++ text "Variable data" ++ line ++
      seq line (fun (vid, init) -> pretty_var vid init) (IH.tolist data)

    let computeFirstPredecessor stmt var_table =
      IH.copy var_table 

    let combineTables (old : t) (var_table : t) =
      let tbl = IH.copy old in
      IH.iter (fun k v -> IH.replace tbl k (IH.find old k || v)) var_table; 
      tbl

    let combinePredecessors (stm : stmt) ~(old : t) (var_table : t) =
      match (compare old var_table) with
        | 0 -> None
        | _ -> Some (combineTables old var_table)

    let doInstr inst var_table =
      let transform tbl_in =
        let update vi =
          if IH.mem tbl_in vi.vid then IH.replace tbl_in vi.vid true else () in
        let _, defs = UD.computeUseDefInstr inst in
        UD.VS.iter update defs;
        tbl_in
      in
        DF.Post transform

    let doStmt stm var_table = DF.Default

    let filterStmt stm = true
  end

module MBU = DF.ForwardsDataFlow ( Upward )  

let partitionAddressTaken (f : fundec) (vars_of_interest : varinfo list) =
  let pu_vars, d_vars = List.partition (fun vi -> not (vi.vaddrof)) vars_of_interest in 
    let init = IH.create 32 in
      List.iter (fun s -> IH.add init s.vid false) pu_vars;
      init, d_vars

let computeUninitialized (f : fundec) (vars : varinfo list) =
  let _ = if (!debug) then
    ignore (E.log "Analyzing function %s\n" f.svar.vname) in 
  let _ = IH.clear Upward.stmtStartData in
  let bdy = f.sbody in
  let slst = bdy.bstmts in
  let fst_stm = List.hd slst in
  let (start_tbl, already_at_top) = partitionAddressTaken f vars in
  let _ = IH.add Upward.stmtStartData fst_stm.sid start_tbl in 
  MBU.compute [fst_stm];
  let passInitialized s =
    if(!debug) then
      ignore (E.log "Instrumenting for statement number: %i looks like: %t \n" s.sid (fun _ -> printStmt defaultCilPrinter () s));
    try
      let tbl = IH.find Upward.stmtStartData s.sid in
      let isInitialized vi  =
        if List.mem vi already_at_top then begin 
          if (!debug) then
            ignore (E.log "Variable: %s always top\n" vi.vname); true end else
               try
                 let result = IH.find tbl vi.vid in
                 if (!debug) then
                   ignore (E.log "Variable: %s is %s\n" vi.vname (if result then "possibly assigned" else "definitely unassigned"));
                   result
               with
                 Not_found -> 
                   if (!debug) then
                     ignore (E.log "Variable: %s was not included in the analysis\n" vi.vname); 
                 raise Not_found 
      in isInitialized
    with
      Not_found -> 
        if (!debug) then
          ignore (E.log "Statement with id: %i is unreachable" s.sid); 
        let isInitialized vi = false in
        isInitialized
    in passInitialized
