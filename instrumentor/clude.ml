open Pretty


type disposition = Include | Exclude

type pattern = disposition * string


let push patterns disposition template =
  patterns := !patterns @ [disposition, template]


let d_pattern (disposition, template) =
  let operator = 
    match disposition with
    | Include -> "include"
    | Exclude -> "exclude"
  in
  text operator ++ text " " ++ text template


let string_of_patterns patterns =
  Pretty.sprint 0 (seq (text ", ") d_pattern patterns)


let register ~flag ~desc ~ident value =
  Options.push ("--exclude-" ^ flag, Arg.String (push value Exclude), "");
  Options.push ("--include-" ^ flag, Arg.String (push value Include), desc);
  Idents.register (ident, fun () -> string_of_patterns !value)


let selected patterns focus =
  let rec dispose = function
    | [] -> Include
    | (disposition, "*") :: _ -> disposition
    | (disposition, template) :: _ when template = focus -> disposition
    | _ :: remainder -> dispose remainder
  in
  match dispose patterns with
  | Include -> true
  | Exclude -> false
