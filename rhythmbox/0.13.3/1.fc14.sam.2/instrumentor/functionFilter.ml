open Cil
open Clude


class filter =
  object (self)
    inherit [string] Clude.filter as super

    val pragmaExclusions = new StringHash.c 0

    method collectPragmas file =
      let iterator = function
	| GPragma (Attr ("sampler_exclude_function", [AStr name]), _) ->
	    pragmaExclusions#add name ()
	| _ -> ()
      in
      iterGlobals file iterator

    method private matches = matchesOrWildcard "*"

    method included focus =
      if pragmaExclusions#mem focus then
	false
      else
	super#included focus

    method private format = Pretty.text

    initializer
      Options.push ("--exclude-function", Arg.String self#addExclude, "");
      Options.push ("--include-function", Arg.String self#addInclude, "<function> instrument this function");
      Idents.register ("FilterFunction", fun () -> self#formatPatterns)
  end


let filter = new filter
