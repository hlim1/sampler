type classification = Check | Fail | Generic


val classifyByName : string -> classification
val classifyStatement : Cil.stmtkind -> classification
