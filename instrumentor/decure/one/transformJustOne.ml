open Cil


class visitor file target =
  object
    inherit Transform.visitor file as super

    method private transform func =
      if func.svar.vname = target then
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
    visitCilFile (new visitor file "cureMe") file
