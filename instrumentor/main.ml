let _ =

  NothingScheme.register ();
  ScalarPairScheme.register ();
  BranchScheme.register ();
  ReturnScheme.register ();

  Phases.main ()
