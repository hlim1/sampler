open Cil
open Pretty


class printer =
  object (self)
    inherit defaultCilPrinterClass as super

    method pStmtKind next () = function
      |	If (predicate, original, instrumented, location) as skind
	when Choices.mem skind ->
	  self#pLineDirective location
            ++ (align
                  ++ text "if"
                  ++ (align
			++ text " (__builtin_expect("
			++ self#pExp () predicate
			++ text ", 1)) "
			++ self#pBlock () original)
                  ++ chr ' '
                  ++ (align
			++ text "else "
			++ self#pBlock () instrumented)
                  ++ unalign)
      |	other ->
	  super#pStmtKind next () other
  end
