open Cil


class virtual visitor : object
  inherit cilVisitor

  method private makeTempVar : string -> typ -> varinfo
end
