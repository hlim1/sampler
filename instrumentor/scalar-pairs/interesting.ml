open Cil


let hasInterestingType varinfo =
  isIntegralType varinfo.vtype || isPointerType varinfo.vtype


let hasInterestingNameLocal varinfo =
  let regexp =
    let pattern =
      let names = ["tmp"; "__result";
		   "__s";
		   "__s1"; "__s1_len";
		   "__s2"; "__s2_len";
		   "__u";
		   "__c"] in
      let alpha = "\\(___[0-9]+\\)?" in
      "\\(" ^ (String.concat "\\|" names) ^ "\\)" ^ alpha ^ "$"
    in
    Str.regexp pattern
  in
  not (Str.string_match regexp varinfo.vname 0)


let hasInterestingNameGlobal varinfo =
  let uninteresting = [
    "sys_nerr";
    "gdk_debug_level"; "gdk_show_events"; "gdk_stack_trace"
  ] in
  not (List.mem varinfo.vname uninteresting)


let isInterestingVar varinfo =
    if hasInterestingType varinfo then
      let hasInterestingName = if varinfo.vglob then
	hasInterestingNameGlobal
      else
	hasInterestingNameLocal
      in
      hasInterestingName varinfo
    else
      false
