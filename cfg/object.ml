open Basics
open Types


let p name stream =
  let compilations = sequence Stream.empty Compilation.p in
  let compilations = compilations stream in
  { objectName = name; compilations = compilations }


(**********************************************************************)


let fixCallees globals { compilations = compilations } =
  List.iter (Compilation.fixCallees globals) compilations


let fixCalleesAll objects =
  let collectExports symtab obj =
    List.fold_left Compilation.collectExports symtab obj.compilations
  in
  let globals = List.fold_left collectExports StringMap.M.empty objects in
  List.iter (fixCallees globals) objects;
  globals
