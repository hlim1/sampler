let memoize worker =
  let known = new HashClass.c 0 in
  fun arg ->
    try
      known#find arg
    with Not_found ->
      let result = worker arg in
      known#add arg result;
      result
