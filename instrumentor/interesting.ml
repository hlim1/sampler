open Cil


let isInterestingType typ =
  isIntegralType typ || isPointerType typ


let hasInterestingName = function
  | {vglob = true; vname = name} ->
      let uninteresting = [
	"sys_nerr";
	"gdk_debug_level"; "gdk_show_events"; "gdk_stack_trace";
	"nextEventCountdown"
      ] in
      not (List.mem name uninteresting)
  | {vglob = false; vname = name} ->
      let regexp =
	let pattern =
	  let names = ["tmp"; "__result";
		       "__s";
		       "__s1"; "__s1_len";
		       "__s2"; "__s2_len";
		       "__u";
		       "__c"] in
	  let scope = "\\([_0-9A-Za-z]+\\$\\)" in
	  let alpha = "\\(___[0-9]+\\)?" in
	  "\\(" ^ scope ^ (String.concat "\\|" names) ^ "\\)" ^ alpha ^ "$"
	in
	Str.regexp pattern
      in
      not (Str.string_match regexp name 0)


let isInterestingVar varinfo =
  isInterestingType varinfo.vtype &&
  hasInterestingName varinfo


let isInterestingLval lval =
  let isInterestingHost = function
    | Var var ->
	hasInterestingName var
    | Mem expr ->
	false
  in

  let isInterestingOffset = function
    | NoOffset -> true
    | Field _ -> false
    | Index _ -> false
  in

  isInterestingType (typeOfLval lval) &&
  isInterestingHost (fst lval) &&
  isInterestingOffset (snd lval)
