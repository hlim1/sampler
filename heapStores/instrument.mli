open Cil

  
class visitor : cilVisitor

val visit : block -> unit

val phase : TestHarness.phase
