open Str


let check candidate prefix =
  let prefixLength = String.length prefix in
  String.length candidate >= prefixLength
    && prefix = Str.first_chars candidate prefixLength
