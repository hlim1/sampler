open Cil


type bumper = Tuples.siteId -> exp -> location -> instr


let build file =
  if !Threads.threads then
    let incrementor = Lval (var (FindFunction.find "atomicIncrementCounter" file)) in
    fun site slot location ->
      Call (None, incrementor, [integer site; slot], location)
  else
    let fieldinfo =
      let compinfo =
	let rec scanner = function
	  | GCompTag ({cname = "CounterTuple"; cstruct = true} as compinfo, _) :: _
	  | GCompTagDecl ({cname = "CounterTuple"; cstruct = true} as compinfo, _) :: _
	    -> compinfo
	  | _ :: rest ->
	      scanner rest
	  | [] ->
	      raise (Missing.Missing "struct CounterTuple")
	in
	scanner file.globals
      in
      getCompField compinfo "values"
    in
    let counterTuples = FindGlobal.find "counterTuples" file in
    fun site slot location ->
      let counter : lval = (Var counterTuples, Index (integer site, Field (fieldinfo, Index (slot, NoOffset)))) in
      Set (counter, increm (Lval counter) 1, location)
