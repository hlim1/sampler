open Cil


let all = new FunctionNameHash.c 0


class virtual c func =
  let sites =
    let list = ref [] in
    all#add func list;
    list
  in

  fun (embodiment : stmt) ->
    object (self)
      initializer
	sites := (self :> c) :: !sites

      method embodiment = embodiment
    end
