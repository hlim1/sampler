open Cil
open Classify


class visitor file =
  object
    inherit TransformVisitor.visitor file as super

    method private collector _ = new Find.visitor
    method private prepatchCalls = DecureCalls.prepatch

    method private shouldTransform func =
      match classifyByName func.svar.vname with
      | Check
      | Fail ->
	  false
      | Generic ->
	  super#shouldTransform func
  end


let phase =
  "Transform",
  fun file ->
    visitCilFile (new visitor file) file
