open Cil


val assumeWeightlessExterns : bool ref


type tester = lval -> bool

val collect : FileInfo.container -> tester
