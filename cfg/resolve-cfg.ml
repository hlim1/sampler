open Types


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

let globals = Object.fixCalleesAll !objs in
Dotty.dump stdout !objs;

let check origin destination =
  let reachable = Transitive.reach origin destination in
  Printf.printf "%d -?-> %d: %b\n\n" origin.nid destination.nid reachable
in
let tiny = StringMap.M.find "tiny" globals in
check tiny.nodes.(1) tiny.nodes.(0)
