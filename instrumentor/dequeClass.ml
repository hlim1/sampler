exception Empty


type 'element node = {
    prev : 'element node ref;
    next : 'element node ref;
    payload : 'element option
  }


let makeSentinel () =
  let rec sentinel = {
    prev = ref sentinel;
    next = ref sentinel;
    payload = None
  } in
  sentinel


class ['element] c =
  object (self)
    val sentinel = makeSentinel ()

    val length = ref 0

    method isEmpty =
      match !(sentinel.prev) == sentinel, !(sentinel.next) == sentinel with
      | false, false ->
	  false
      | true, true ->
	  true
      | _ ->
	  failwith "deque error: internally inconsistent sentinel links"

    method length = !length

    method private payload node =
      match node.payload with
      | None ->
	  failwith "deque error: non-sentinel node without payload"
      | Some result ->
	  result
	    
    method private link prev next element =
      let node = {
	prev = ref prev;
	next = ref next;
	payload = Some element;
      }
      in
      prev.next := node;
      next.prev := node;
      incr length
	
    method private unlink node =
      if self#isEmpty then
	raise Empty
      else
	begin
	  !(node.next).prev := !(node.prev);
	  !(node.prev).next := !(node.next);
	  decr length;
	  self#payload node
	end

    method pushFront =
      self#link sentinel !(sentinel.next)

    method pushBack =
      self#link !(sentinel.prev) sentinel

    method popFront =
      self#unlink !(sentinel.next)

    method popBack =
      self#unlink !(sentinel.prev)

    method private iter follow (action : _ -> unit) =
      let rec scan node =
	if node != sentinel then
	  begin
	    action (self#payload node);
	    scan !(follow node)
	  end
      in
      scan !(follow sentinel)

    method iterFromFront =
      self#iter (fun node -> node.next)

    method iterFromBack =
      self#iter (fun node -> node.prev)

(*
    method map : 'transformed . ('element -> 'transformed) -> 'transformed c
	= fun mutate ->
	  let result = new c in
	  let convert element =
	    result#pushBack (mutate element)
	  in
	  self#iter convert;
	  result
*)

    method private fold : 'accumulator . ('element node -> 'element node ref) -> ('accumulator -> 'element -> 'accumulator) -> 'accumulator -> 'accumulator
        = fun follow reduce seed ->
	  let rec scan node accumulator =
	    if node == sentinel then
	      accumulator
	    else
	      let accumulator' = reduce accumulator (self#payload node) in
	      scan !(follow node) accumulator'
	  in
	  scan !(follow sentinel) seed

    method foldFromFront : 'accumulator . ('accumulator -> 'element -> 'accumulator) -> 'accumulator -> 'accumulator =
      self#fold (fun node -> node.next)

    method foldFromBack : 'accumulator . ('accumulator -> 'element -> 'accumulator) -> 'accumulator -> 'accumulator =
      self#fold (fun node -> node.prev)
  end
