let main () =
  let nonflag argument = argument.[0] != '-' in
  match List.tl (Array.to_list Sys.argv) with
  | instrumentor :: compiler :: arguments
    when nonflag instrumentor && nonflag compiler ->
      let homeDir = (Filename.dirname Sys.executable_name) ^ "/../../.." in
      ignore (new LogDriver.c homeDir instrumentor compiler arguments)
  | _ ->
      prerr_endline ("usage: " ^ Sys.argv.(0) ^ " <instrumentor> <compiler> [<arguments> ...]");
      exit 2


;;


Unix.handle_unix_error main ()
