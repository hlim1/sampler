open Cil


let target = ref ""

let _ =
  Options.registerString
    ~flag:"only"
    ~desc:"<function> sample only in this function [required]"
    ~ident:"Only"
    target


class visitor file =
  object
    inherit Transform.visitor file as super

    method private transform func =
      if func.svar.vname = !target then
	super#transform func
      else
	begin
	  IsolateInstructions.visit func;
	  RemoveChecks.visit func;
	  []
	end
  end


let phase =
  "Transform",
  fun file ->
    if (!target = "") then
      raise (Arg.Bad "must identify sampled function")
    else
      let visitor = new visitor file in
      visitCilFile visitor file
