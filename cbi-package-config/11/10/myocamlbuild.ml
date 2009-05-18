open Ocamlbuild_plugin
open Command


;;


dispatch begin
  function
    | After_rules ->
	(* the main CIL library *)
	let cil = "/usr/lib/cil" in
	flag ["use_cil"; "compile"] (S [A "-I"; P cil]);
	flag ["use_cil"; "link"; "byte"] (S [P (cil / "cil.cma")]);
	flag ["use_cil"; "link"; "native"] (S [P (cil / "cil.cmxa")]);

    | _ ->
	()
end
