open Cil


type strongest = Declared of varinfo | Defined of fundec

val build : file -> strongest VariableNameMap.container
