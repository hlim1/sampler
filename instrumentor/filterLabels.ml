open Cil


let nonLabel = function
  | Label _ -> false
  | _ -> true


let retainNone =
    List.filter nonLabel
	

let rec retainOne = function
  | [] ->
      failwith "no jump target label in labels list"
	
  | Label _ as first :: rest ->
      first :: retainNone rest

  | other :: rest ->
      other :: retainOne rest


(**********************************************************************)


class numberStatements = object
  inherit FunctionBodyVisitor.visitor

  val nextSid = ref 1

  method vstmt stmt =
    stmt.sid <- !nextSid;
    incr nextSid;
    DoChildren
end


class collectDestinations = object
  inherit FunctionBodyVisitor.visitor

  val destinations = new StmtSet.container
  method result = destinations

  method vstmt stmt =
    begin
      match stmt.skind with
      | Goto (dest, _) ->
	  destinations#add !dest
      | _ -> ()
    end;
    DoChildren
end


class reduceLabels destinations = object
  inherit FunctionBodyVisitor.visitor

  method vstmt stmt =
    let filter = if destinations#mem stmt then retainOne else retainNone in
    stmt.labels <- filter stmt.labels;
    DoChildren
end


class visitor = object
  inherit FunctionBodyVisitor.visitor

  method vfunc func =
    ignore (visitCilFunction (new numberStatements) func);

    let destinations =
      let collector = new collectDestinations in
      ignore (visitCilFunction (collector :> cilVisitor) func);
      collector#result
    in
	
    let simplifier = new reduceLabels destinations in
    ignore (visitCilFunction simplifier func);
    SkipChildren
end


let phase =
  "FilterLabels",
  visitCilFileSameGlobals new visitor
