open Unix


class virtual c arguments =
  object (self)
    val mutable verbose = false

    initializer
      self#build

    method private virtual build : unit

    method private parse arguments =
      let rec consume = function
	| [] -> ()
	| flag :: rest ->
	    let remainder = self#parse_1 flag rest in
	    consume remainder
      in
      consume arguments

    method private virtual parse_1 : string -> string list -> string list

    method private trace arg0 argv =
      if verbose then
	let show arg =
	  prerr_char ' ';
	  prerr_string arg
	in
	prerr_string arg0;
	List.iter show argv;
	prerr_newline ()

    method private run arg0 argv =
      self#trace arg0 argv;
      self#runOut arg0 argv stdout

    method private runOut arg0 argv outFd =
      let child = create_process arg0 (Array.of_list (arg0 :: argv)) stdin outFd stderr in
      match snd (waitpid [] child) with
      | WEXITED 0 -> ()
      | WEXITED code
      | WSIGNALED code
      | WSTOPPED code ->
	  exit code
  end
