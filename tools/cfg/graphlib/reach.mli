type ('node, 'edge) follow = 'node -> ('edge * 'node) list

type 'node trace = 'node -> unit


type ('node, 'edge) probe = 'node trace -> ('node, 'edge) follow -> 'node -> 'node -> bool
