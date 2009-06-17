open Ocamlbuild_plugin

;;

dispatch begin function
  | After_rules ->
      ocaml_lib ~extern:true ~dir:"+cil" "cil"
  | _ ->
      ()
end
