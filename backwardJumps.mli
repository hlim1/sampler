open Cil
open PatchSites


val prepatch : WeighPaths.weightsMap -> stmt list -> patchSites

val patch : Duplicate.clonesMap -> patchSites -> unit
