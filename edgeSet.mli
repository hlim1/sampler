open Cil


type edge = stmt * stmt

class container : [edge] SetClass.container
