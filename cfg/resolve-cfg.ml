let argSpecs = []


let objs = ref []


let doOne filename =
  let channel = open_in filename in
  let stream = Stream.of_channel channel in
  let obj = Object.p filename stream in
  objs := obj :: !objs

;;


Arg.parse argSpecs doOne
("Usage:" ^ Sys.executable_name ^ " <module>.cfg ...");

Object.resolveAll !objs;
Dotty.dump stdout !objs
