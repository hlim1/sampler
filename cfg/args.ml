let process () =
  let argSpecs = [] in
  let objects = ref [] in

  let doOne filename =
    let channel = open_in filename in
    let stream = Stream.of_channel channel in
    objects := (Object.parse filename stream) :: !objects
  in

  Arg.parse argSpecs doOne
    ("Usage:" ^ Sys.executable_name ^ " <module>.cfg ...");

  List.iter Object.addNodes !objects;
  List.iter Object.addEdges !objects
