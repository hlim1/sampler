let saveImplications =
  Options.registerString
    ~flag:"save-implications"
    ~desc:"save implication information in the named file"
    ~ident:""

let visit impls digest =
  if !saveImplications <> "" then
    TestHarness.time "saving implications"
      (fun () ->
        let channel = open_out !saveImplications in
        output_string channel "<implications>\n";
        Implications.printAll digest channel impls;
        output_string channel "</implications>\n";
        close_out channel)
