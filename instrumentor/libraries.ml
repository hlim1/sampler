let libraries = [
  "/usr/lib/libc_nonshared.a";
  "-D /lib/libc.so.6";
  "-D /lib/libm.so.6"
]


let functions =
  let collection = new StringSet.container in

  let collectLibrary lib =
    let command = "nm --defined-only -g -p " ^ lib ^ " | awk '$2 ~ /[TW]/ { print $3 }'" in
    let channel = Unix.open_process_in command in
    let reading = ref true in
    while !reading do
      try
	let symbol = input_line channel in
	collection#add symbol
      with End_of_file ->
	reading := false
    done
  in

  List.iter collectLibrary libraries;
  collection
