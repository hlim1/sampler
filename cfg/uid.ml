let nextId = ref 0

let next () =
  let result = !nextId in
  incr nextId;
  result
