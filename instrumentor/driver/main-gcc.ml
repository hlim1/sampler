let main () =
  let nonflag argument = argument.[0] != '-' in
  match List.tl (Array.to_list Sys.argv) with
  | compiler :: arguments
    when nonflag compiler ->
      ignore (new GccDriver.c compiler arguments)
  | _ ->
      prerr_endline ("usage: " ^ Sys.argv.(0) ^ " <compiler> [<arguments> ...]");
      exit 2


;;


Unix.handle_unix_error main ()
