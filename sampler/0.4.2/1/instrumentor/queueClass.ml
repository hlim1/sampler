class ['element] container =
  object
    val storage : 'element Queue.t = Queue.create ()

    method add element = Queue.add element storage

    method clear = Queue.clear storage

    method iter iterator = Queue.iter iterator storage

    method fold
	: 'result . (('result -> _ -> 'result) -> 'result -> 'result)
	= fun folder basis ->
	  Queue.fold folder basis storage
  end
