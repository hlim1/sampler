open Cil


let find name file =
  let rec scan = function
    | GCompTag ({cstruct = true; cname = cname} as info, _) :: _
      when cname = name ->
	info
    | _ :: rest ->
	scan rest
    | [] ->
	failwith ("cannot find struct " ^ name)
  in
  scan file.globals
