type ('node, 'edge) follow = 'node -> ('edge * 'node) list

type 'node trace = 'node -> unit


val reach : 'node trace -> ('node, _) follow -> 'node -> 'node -> bool
