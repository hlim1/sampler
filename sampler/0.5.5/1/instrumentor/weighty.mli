open Cil


val assumeWeightlessExterns : bool ref


type tester = lval -> bool

val collect : file -> FileInfo.container -> tester
