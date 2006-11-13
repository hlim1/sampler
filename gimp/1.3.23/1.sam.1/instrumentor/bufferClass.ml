class c size =
  object
    val buffer = Buffer.create size

    method contents = Buffer.contents buffer
    method addString = Buffer.add_string buffer
    method addChar = Buffer.add_char buffer
  end
