open Cil

type cfg = stmt * stmt list
      
val cfg : fundec -> cfg
