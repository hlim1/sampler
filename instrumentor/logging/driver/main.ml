exception Usage


let main () =
  let isFlag argument = argument.[0] == '-' in
  try
    match List.tl (Array.to_list Sys.argv) with
    | inst :: rest
      when not (isFlag inst) ->
	let rec collect = function
	  | flag :: rest when isFlag flag ->
	      let instFlags, cc, ccFlags = collect rest in
	      flag :: instFlags, cc, ccFlags
	  | cc :: ccFlags ->
	      [], cc, ccFlags
	  | _ -> raise Usage
	in
	let instFlags, cc, ccFlags = collect rest in
	let homeDir = (Filename.dirname Sys.executable_name) ^ "/../../.." in
	ignore (new LogDriver.c homeDir (inst, instFlags) (cc, ccFlags))
    | _ ->
	raise Usage

  with Usage ->
    prerr_endline ("usage: " ^ Sys.argv.(0) ^ " <instrumentor> [<inst-flags> ...] <cc> [<cc-arguments> ...]");
    exit 2


;;


Unix.handle_unix_error main ()
