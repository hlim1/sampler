open Cil
open Clude
open Pretty


class filter =
  object (self)
    inherit [location] Clude.filter

    method private matches template focus =
      matchesOrWildcard (-1) template.line focus.line &&
      matchesOrWildcard "*" template.file focus.file

    method private format = function
      | {file; line=(-1); _} ->
	  text file ++ text ":*"
      | fileAndLine ->
	  d_loc () fileAndLine

    method private makeLocation file line =
      {file; line; byte=(-1)}

    method private fileToLocation file =
      self#makeLocation file (-1)

    method private addExcludeFile file =
      self#addExclude (self#fileToLocation file)

    method private addIncludeFile file =
      self#addInclude (self#fileToLocation file)

    method private fileAndLineToLocation fileAndLine =
      Scanf.sscanf fileAndLine "%s@:%u%!" self#makeLocation

    method private addExcludeLocation fileAndLine =
      self#addExclude (self#fileAndLineToLocation fileAndLine)

    method private addIncludeLocation fileAndLine =
      self#addInclude (self#fileAndLineToLocation fileAndLine)

    initializer
      Options.push ("--exclude-file", Arg.String self#addExcludeFile, "");
      Options.push ("--include-file", Arg.String self#addIncludeFile, "<file-name> instrument this file");
      Options.push ("--exclude-location", Arg.String self#addExcludeLocation, "");
      Options.push ("--include-location", Arg.String self#addIncludeLocation, "<file-name:line-number> instrument this location");
      Idents.register ("FilterLocation", fun () -> self#formatPatterns)
  end


let filter = new filter
