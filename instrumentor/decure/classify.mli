type classification = Check | Fail | Init | Generic


val classifyByName : string -> classification
val classifyStatement : Cil.stmtkind -> classification
