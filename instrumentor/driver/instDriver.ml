open Filename
open Unix


let savedTempName filename strip append =
  let base = basename filename in
  let root =
    if check_suffix base strip then
      chop_suffix base strip
    else
      base
  in
  root ^ append



class virtual c homeDir (instrumentor, instArgs) compiler =
  object (self)
    inherit GccDriver.c compiler as super

    method private parse =
      finalFlags <- "-Wno-unused-label" :: finalFlags;
      super#parse

    method private extraLibs =
      let dir = homeDir ^ "/libcountdown" in
      ["-Wl,-rpath," ^ dir; "-L" ^ dir; "-lcountdown"]

    method private prepare filename =
      let handler =
	let check = check_suffix filename in
	if check ".inst.c" then
	  self#preparePostprocess
	else if check ".inst.i" then
	  super#prepare
	else if check ".c" then
	  self#preparePreprocess
	else if check ".i" then
	  self#prepareInstrument
	else
	  super#prepare
      in
      handler filename

    method private runCpp input extraFlags =
      let output =
	if saveTemps then
	  savedTempName input ".c" ".i"
	else
	  fst (TempFile.get ".i")
      in
      self#run (fst compiler, ("-E" :: input :: "-o" :: output :: extraFlags @ flags));
      output

    method private preparePreprocess input =
      let output = self#runCpp input ["-include"; self#extraHeader] in
      self#prepareInstrument output

    method private prepareInstrument input =
      let outputName, outputFd =
	if saveTemps then
	  let name = savedTempName input ".i" ".inst.c" in
	  name, openfile name [O_WRONLY; O_CREAT; O_TRUNC] 0o666
	else
	  TempFile.get ".inst.c"
      in
      self#trace (instrumentor, instArgs @ [input; (">" ^ outputName)]);
      self#runOut (instrumentor, instArgs @ [input]) outputFd;
      self#preparePostprocess outputName

    method private preparePostprocess input =
      self#runCpp input []
  end
