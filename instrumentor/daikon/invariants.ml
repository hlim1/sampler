open Cil


let comparison op left right =
  BinOp (op, left, right, intType)


let unary typsig varinfo =
  match typsig with
  | TSPtr _ ->
      [comparison Eq varinfo zero]
  | _ ->
      []


let binary typsig left right =
  match typsig with
  | TSPtr _
  | TSBase (TInt _) ->
      let rightExp = Lval (var right) in
      [comparison Eq left rightExp;
       comparison Lt left rightExp]
  | _ ->
      []


let propose typsig left rights =
  let leftExp = Lval (var left) in
  List.concat (unary typsig leftExp ::
	       List.map (binary typsig leftExp) rights)
