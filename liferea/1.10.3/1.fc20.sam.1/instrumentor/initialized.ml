open Cil
open Reachingdefs
open Pretty


module VarInitsDFA =
  struct
    let whitelist = Inthash.create 32
    let debug = false (* turn on to print output of Reachingdefs *)

    (* Pretty print the reaching definition data for a function *)
    let myppFdec () fdec =
      seq ~sep:line
        ~doit:(fun stm ->
               let ivih = Inthash.find ReachingDef.stmtStartData stm.sid in
               Pretty.dprintf "\n============== Statement %d ===============\n%a\n==== Reaching Defs ====\n%a\n"
                              stm.sid
                              d_stmt stm
                              ReachingDef.pretty ivih)
        ~elements:fdec.sallstmts

    let analyze func vars =
      (* extreme pointer conservatism: if address is *ever* taken,
       * assume var is always initialized *)
      Inthash.clear whitelist;
      let iterator var =
          if var.vaddrof then Inthash.add whitelist var.vid var.vname
      in
      List.iter iterator vars;

      Reachingdefs.computeRDs func;
      if debug then
        let varRepr _ =
          text "==== Var IDs ====\n" ++
          seq ~sep:line ~doit:(fun var -> Pretty.dprintf "%d %s" var.vid var.vname) ~elements:vars
        in
        ignore(Pretty.eprintf "%t\n%a\n" varRepr myppFdec func)

    let possiblyInit stmt =
      (* A variable is possibly initialized if
          * it's address is taken (i.e. present in waitlist) or
          * some definiton of that variable reaches this stmt. *)
      match getRDs stmt.sid with
      | None -> fun _ -> false
      | Some (_, _, iosh) ->
        fun var ->
          if Inthash.mem iosh var.vid then
            (IOS.max_elt (Inthash.find iosh var.vid) != None)
          else
            Inthash.mem whitelist var.vid

    let possiblyUnInit stmt =
      (* A variable is possibly uninitialized if None is in the
       * reaching definition of that variable *)
      match getRDs stmt.sid with
      | None -> fun _ -> true
      | Some (_, _, iosh) ->
        fun var ->
          if Inthash.mem iosh var.vid then
            (IOS.mem None (Inthash.find iosh var.vid))
          else
            false

  end


(* perform a new analysis, destroying any previous results in the process *)
let analyze func vars =
  VarInitsDFA.analyze func vars

let possiblyInit stmt =
  VarInitsDFA.possiblyInit stmt

let possiblyUnInit stmt =
  VarInitsDFA.possiblyUnInit stmt

