type split = Before | After

type node = split * Types.Statement.key

type edge = Flow | Call | Return


let graph = new Graph.graph
