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

      method vstmt stmt =
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
        let doOneLabel label =
          match label with
          | Case (labelExp, _) ->
            let selector = BinOp (Eq, predLval, labelExp, intType) in
            let siteInfo = new ExprSiteInfo.c func location labelExp in
            let bump, _ = tuples#addSiteExpr siteInfo selector in
            bump
          | _ -> mkEmptyStmt ()
        in
        let doOneCase caseStmt = List.map doOneLabel caseStmt.labels in
        let instrumentation = List.concat (List.map doOneCase cases) in
        let switch = mkStmt (Switch(predLval, implementation, cases, location)) in
        let stmtList = List.concat [[assign]; instrumentation; [switch]] in
        let replacement = Block (mkBlock stmtList) in
        ChangeDoChildrenPost (stmt, postpatch replacement)

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
              let bump, _ = tuples#addSiteExpr siteInfo selector in
              bump
            in
            match (resolve funptr) with
            | Known callees when List.length callees > 1 ->
              let instrumentation = List.map doOneCallee callees in
              let replacement = mkStmt stmt.skind in
              ignore(fnsWithIndirectCalls#add func 1);
              stmt.skind <- Block (mkBlock (List.append instrumentation
                            [replacement]));
            | _ -> ()
            end;
            SkipChildren
        | _ -> DoChildren
    end
