val assumeWeightlessExterns : bool ref


type tester = Calls.info -> bool

val collect : Prepare.infos -> tester
