val assumeWeightlessExterns : bool ref


type tester = Cil.exp -> bool

val collect : FileInfo.container -> tester
