open Cil
open Dynamic

let extraEdgeProfiles =
  Options.registerBoolean
    ~flag:"extra-edge-profiles"
    ~desc:"collect edge profiles for switch statements and indirect calls (adds a branch-site for every case statement and every indirect callee)"
    ~ident:"extraEdgeProfiles"
    ~default:false

let postpatch replacement statement =
  statement.skind <- replacement;
  statement

let fnsWithIndirectCalls = new FunctionNameHash.c 1

let shouldMoveToEnd fdec = fnsWithIndirectCalls#mem fdec

class visitor file =
  let marker = Blast.predicateMarker2 file in
  fun (tuples : Counters.manager) func ->
    object (self)
      inherit SiteFinder.visitor

      method! vstmt stmt =
	match stmt.skind with
	| If (predicate, thenClause, elseClause, location)
	  when self#includedStatement stmt ->
	    let predTemp = var (Locals.makeTempVar func (typeOf predicate)) in
	    let predLval = Lval predTemp in
	    let selector = BinOp (Ne, predLval, zero, intType) in
	    let siteInfo = new ExprSiteInfo.c func location predicate in
	    let decide = mkStmtOneInstr (Set (predTemp, predicate, location)) in
	    let bump, siteId = tuples#addSiteExpr siteInfo selector in
	    let marker = marker siteId predLval location in
	    let branch = mkStmt (If (predLval, thenClause, elseClause, location)) in
	    let replacement = Block (mkBlock [decide; bump; marker; branch]) in
	    ChangeDoChildrenPost (stmt, postpatch replacement)

    | Switch (switchExp, implementation, cases, location)
	  when !extraEdgeProfiles && self#includedStatement stmt ->
        let predTemp = var (Locals.makeTempVar func (typeOf switchExp)) in
        let predLval = Lval predTemp in
        let assign = mkStmtOneInstr (Set (predTemp, switchExp, location)) in
        let doOneLabel aggr label =
          match label with
          | Case (labelExp, _) ->
            let selector = BinOp (Eq, predLval, labelExp, intType) in
            let siteInfo = new ExprSiteInfo.c func location labelExp in
            let offset = (Index (selector, NoOffset)) in
            let impl, _ = tuples#selectorToImpl siteInfo offset in
            List.append aggr [mkStmt impl, siteInfo]
          | _ -> aggr
        in
        let doOneCase caseStmt = List.fold_left doOneLabel [] caseStmt.labels in
        let impls, infos = List.split (List.concat (List.map doOneCase cases)) in
        if List.length infos > 1 then
          (* put instrumentation for all case-statements
           * in the first case-site's implementation. *)
          let clump = Block (mkBlock impls) in
          let firstPatch = tuples#addImplementation (List.hd infos) clump in
          let switch = mkStmt (Switch(predLval, implementation, cases, location)) in
          let stmtList = List.concat [[assign]; [firstPatch]; [switch]] in
          let replacement = Block (mkBlock stmtList) in
          ChangeDoChildrenPost (stmt, postpatch replacement)
        else
          DoChildren

	| _ ->
      match IsolateInstructions.isolated stmt with
        | Some (Call (_, Lval ((Mem _, _) as funptr), _, location))
          when !extraEdgeProfiles
          && self#includedLocation location ->
            begin
            let doOneCallee callee =
              let expr = Lval (Var callee, NoOffset) in
              let selector = BinOp (Eq, Lval funptr, expr, intType) in
              let siteInfo = new ExprSiteInfo.c func location expr in
              let offset = Index (selector, NoOffset) in
              let impl, _ = tuples#selectorToImpl siteInfo offset in
              (mkStmt impl, siteInfo)
            in
            match (resolve funptr) with
            | Known callees when List.length callees > 1 ->
              let impls, infos = List.split (List.map doOneCallee callees) in
              (* put instrumentation for all indirect-calls
               * in the first indirect-call's implementation *)
              let clump = Block (mkBlock impls) in
              let firstPatch = tuples#addImplementation (List.hd infos) clump in
              let replacement = mkStmt stmt.skind in
              ignore(fnsWithIndirectCalls#add func 1);
              stmt.skind <- Block (mkBlock [firstPatch; replacement]);
            | _ -> ()
            end;
            SkipChildren
        | _ -> DoChildren
    end
