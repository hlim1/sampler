class virtual visitor file =
  object
    inherit Manager.visitor file as super

    method private finalize =
      Invariant.register file;
      super#finalize
  end
