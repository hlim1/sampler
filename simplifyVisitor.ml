open Cil


class virtual visitor initialFunction = object
  inherit FunctionBodyVisitor.visitor

  val currentFunction = ref initialFunction

  method vfunc func =
    currentFunction := func;
    DoChildren

  method vstmt _ = DoChildren
      
  method private makeTempVar name =
    if !currentFunction == dummyFunDec then
      begin
	ignore(bug "cannot make temporary variable outside of function");
	raise Errormsg.Error
      end
    else
      Cil.makeTempVar !currentFunction ~name:name
end
