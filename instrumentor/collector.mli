open Cil


class type visitor =
  object
    inherit cilVisitor

    method sites : stmt list
    method globals : global list
  end
