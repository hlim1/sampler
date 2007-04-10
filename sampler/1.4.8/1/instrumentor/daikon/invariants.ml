open Cil


let propose file =
  let intmax_t =
    let rec seek = function
      | GType ({ tname = "intmax_t"; ttype = typ }, _) :: _ ->
	  typ
      | _ :: rest ->
	  seek rest
      | [] ->
	  raise Not_found
    in
    seek file.globals
  in

  fun typsig left rights ->

    let binop =
      let leftExp = Lval (var left) in
      fun op right ->
	BinOp (op, leftExp, right, intmax_t)
    in

    let unary =
      match typsig with
      | TSPtr _ -> [binop Eq zero]
      | _ -> []
    in

    let binary right =
      let minus = match typsig with
      | TSPtr _ -> Some MinusPP
      | TSBase (TInt _) -> Some MinusA
      | _ -> None
      in
      match minus with
      | Some op -> [binop op (Lval (var right))]
      | None -> []
    in

    List.concat (unary :: List.map binary rights)
