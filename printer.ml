open Cil
open Pretty


class printer : cilPrinter =
  object (self)
    inherit defaultCilPrinterClass as super

    method pStmt () statement =
      failwith "foo!";
      match statement.skind with
      |	If (predicate, original, instrumented, location) as skind
	when Choices.mem skind ->
	  self#pLineDirective location
            ++ (align
                  ++ text "if"
                  ++ (align
			++ text " (__builtin_expect("
			++ self#pExp () predicate
			++ text ", 0)) "
			++ self#pBlock () original)
                  ++ chr ' '
                  ++ (align
			++ text "else "
			++ self#pBlock () instrumented)
                  ++ unalign)
      |	_ ->
	  super#pStmt () statement
  end
