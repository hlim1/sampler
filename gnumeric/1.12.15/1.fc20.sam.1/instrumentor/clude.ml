open Pretty


type disposition = Include | Exclude


let d_pattern formatter (disposition, template) =
  let operator =
    match disposition with
    | Include -> "include"
    | Exclude -> "exclude"
  in
  text operator ++ text " " ++ formatter template


let matchesOrWildcard wildcard template focus =
  template = wildcard || template = focus


class virtual ['a] filter =
  object (self)
    val mutable patterns = []

    method private append disposition template =
      patterns <- patterns @ [disposition, template]

    method addExclude = self#append Exclude
    method addInclude = self#append Include

    method private virtual matches : 'a -> 'a -> bool

    method included focus =
      let rec dispose = function
	| [] -> Include
	| (disposition, template) :: _
	  when self#matches template focus ->
	    disposition
	| _ :: rest ->
	    dispose rest
      in
      match dispose patterns with
      | Include -> true
      | Exclude -> false

    method private virtual format : 'a -> doc

    method private formatPatterns =
      Pretty.sprint ~width:0 (seq ~sep:(text ", ") ~doit:(d_pattern self#format) ~elements:patterns)
  end
