open Cil
open PatchSites


val split : fundec -> stmt list

val prepatch : WeighPaths.weightsMap -> stmt list -> PatchSites.patchSites

val patch : Duplicate.clonesMap -> PatchSites.patchSites -> unit
