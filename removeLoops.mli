open Cil


class visitor : cilVisitor

val phase : unit -> TestHarness.phase

val visit : fundec -> unit
