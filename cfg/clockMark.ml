type t = int

let now = ref 1

let mark () = !now
let unmark () = !now - 1

let marked stamp = stamp == !now
let reset () = incr now
