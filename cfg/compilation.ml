open Basics
open Types


let p =
  let header =
    parser
	[< ''*'; ''\t'; ''0'; ''.'; ''1'; ''\n' >] ->
	  ()
  in

  let name = wordLine in

  let signature =
    let hex = parser [< ''0' .. '9' | 'a' .. 'f' as digit >] -> digit in
    parser
	[<
	  hex_00 = hex; hex_01 = hex; hex_02 = hex; hex_03 = hex;
	  hex_04 = hex; hex_05 = hex; hex_06 = hex; hex_07 = hex;
	  hex_08 = hex; hex_09 = hex; hex_10 = hex; hex_11 = hex;
	  hex_12 = hex; hex_13 = hex; hex_14 = hex; hex_15 = hex;
	  hex_16 = hex; hex_17 = hex; hex_18 = hex; hex_19 = hex;
	  hex_20 = hex; hex_21 = hex; hex_22 = hex; hex_23 = hex;
	  hex_24 = hex; hex_25 = hex; hex_26 = hex; hex_27 = hex;
	  hex_28 = hex; hex_29 = hex; hex_30 = hex; hex_31 = hex;
	  ''\n'
	    >]
	->
	  Printf.sprintf
	    "%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c"
	    hex_00 hex_01 hex_02 hex_03 hex_04 hex_05 hex_06 hex_07
	    hex_08 hex_09 hex_10 hex_11 hex_12 hex_13 hex_14 hex_15
	    hex_16 hex_17 hex_18 hex_19 hex_20 hex_21 hex_22 hex_23
	    hex_24 hex_25 hex_26 hex_27 hex_28 hex_29 hex_30 hex_31
  in

  let functions = sequenceLine Function.p in

  parser
      [< _ = header; name = name; signature = signature; functions = functions >] ->
	{ sourceName = name; signature = signature; functions = functions }


(**********************************************************************)


let collectExports symtab { functions = functions } =
  List.fold_left Function.collectExports symtab functions


let fixCallees globals { functions = functions } =
  let locals = List.fold_left Function.collectAll StringMap.M.empty functions in
  let environment = { locals = locals; globals = globals } in
  List.iter (Function.fixCallees environment) functions
