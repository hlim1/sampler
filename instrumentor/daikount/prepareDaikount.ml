class virtual visitor (file : Cil.file) =
  object
    inherit Prepare.visitor

    method finalize file =
      Invariant.register file
  end
