module ChoiceSet = Set.Make(
  struct
    type t = Cil.stmtkind
    let compare = compare
  end
 )


let choices = ref ChoiceSet.empty


let add choice =
  choices := ChoiceSet.add choice !choices


let mem choice =
  ChoiceSet.mem choice !choices
