let mapconcat transformer =
  let folder results item = (transformer item) @ results in
  List.fold_left folder
