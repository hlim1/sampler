open Cil


class weightsMap : [Weight.t] StmtIdHash.c

val weigh : Site.t list -> stmt list -> weightsMap
