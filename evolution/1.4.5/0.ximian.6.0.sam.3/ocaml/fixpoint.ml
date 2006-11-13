let compute refine =
  let madeProgress = ref true in
  while !madeProgress do
    madeProgress := false;
    refine madeProgress
  done
