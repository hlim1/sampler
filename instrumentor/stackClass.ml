class ['a] container = object
    
  val storage : 'a Stack.t = Stack.create ()

  method push key =
    Stack.push key storage

  method pop =
    Stack.pop storage

  method isEmpty =
    Stack.is_empty storage
end
