open Cil

type headers = Edge.edge SetClass.container

val collectHeaders : Cfg.cfg -> headers

class visitor : cilVisitor
