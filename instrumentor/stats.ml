let showStats = ref false

let _ =
  Options.registerBoolean
    showStats
    ~flag:"show-stats"
    ~desc:"show various summary statistics"
    ~ident:"ShowStats"
