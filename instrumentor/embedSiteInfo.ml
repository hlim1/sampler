open Cil


let saveSiteInfo =
  let value = ref "" in
  Options.push ("--save-site-info",
		Arg.Set_string value,
		"save instrumentation site info in the named file");
  value


let visit schemes digest =
  if !saveSiteInfo <> "" then
    TestHarness.time "  saving site info"
      (fun () ->
	let channel = open_out !saveSiteInfo in
	List.iter
	  (fun scheme -> scheme#saveSiteInfo digest channel)
	  schemes)
