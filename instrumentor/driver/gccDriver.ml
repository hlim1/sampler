open Str


exception Special


type goal = Assembly | Object | Executable


let changeSuffix =
  let pattern = regexp "\\.[^.]*$" in
  fun filename newSuffix ->
    replace_first pattern newSuffix (Filename.basename filename)


class c compiler arguments =
  object (self)
    inherit Driver.c arguments

    val mutable flags = []
    val mutable finalFlags = []
    val mutable outfile = None
    val mutable goal = Executable

    val mutable saveTemps = false

    val mutable inputs = []
    val mutable anyInputName = ""

    method private prepare filename = filename

    method private extraLibs = []


    method private parse_1 flag rest =
      match flag, rest with
      | "-c", _ ->
	  goal <- Object;
	  finalFlags <- finalFlags @ [flag];
	  rest

      | "-S", _ ->
	  goal <- Assembly;
	  finalFlags <- finalFlags @ [flag];
	  rest

      | "-o", argument :: rest ->
	  outfile <- Some argument;
	  rest

      | "-v", _ ->
	  verbose <- true;
	  flags <- flags @ [flag];
	  rest
	    
      | "-x", argument :: rest ->
	  failwith ("unsupported flag: " ^ flag)

      | "-fsyntax-only", _ ->
	  raise Special

      | "-save-temps", _ ->
	  saveTemps <- true;
	  flags <- flags @ [flag];
	  rest

      | "-include", argument :: rest
      | "-imacros", argument :: rest
      | "-idirafter", argument :: rest
      | "-iprefix", argument :: rest
      | "-iwithprefix", argument :: rest
      | "-iwithprefixbefore", argument :: rest
      | "-isystem", argument :: rest
      | "-isystem-c++", argument :: rest ->
	  flags <- flags @ [flag; argument];
	  rest

      | "-E", _
      | "-M", _
      | "-MM", _ ->
	  raise Special

      | "-Xlinker", argument :: rest
      | "-u", argument :: rest
      | "-I", argument :: rest
      | "-L", argument :: rest
      | "-b", argument :: rest
      | "-V", argument :: rest
      | "-G", argument :: rest ->
	  flags <- flags @ [flag; argument];
	  rest

      | print, _
	when Prefix.check print "-print-" ->
	  raise Special

      | library, _
	when Prefix.check library "-l" ->
	  let input _ = library in
	  inputs <- inputs @ [input];
	  rest

      | _
	when flag.[0] == '-' ->
	  flags <- flags @ [flag];
	  rest

      | filename, _ ->
	  let builder () = self#prepare filename in
	  inputs <- inputs @ [builder];
	  anyInputName <- filename;
	  rest


    method private build =
      try
	self#parse;

	let built =
	  let build builder = builder () in
	  List.map build inputs
	in

	let outfileName = match outfile with
	| Some target -> target
	| None ->
	    match goal with
	    | Assembly ->
		changeSuffix anyInputName ".s"
	    | Object ->
		changeSuffix anyInputName ".o"
	    | Executable ->
		"a.out"
	in

	let extraLibs = if goal == Executable then self#extraLibs else [] in

	self#run compiler ("-o" :: outfileName :: flags @ finalFlags @ built @ extraLibs)

      with Special ->
	self#run compiler arguments
  end
