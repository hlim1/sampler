exception Found


type ('node, 'edge) edge = ('node * 'edge * 'node)


class ['node, 'nodeData, 'edge] graph =
  object (self)
    val mutable nodes = new HashClass.c 0
    val mutable edges = new HashClass.c 0

    val mutable succs = new HashClass.c 0
    val mutable preds = new HashClass.c 0


    method addNode (node : 'node) (data : 'nodeData) =
      assert (not (self#isNode node));
      nodes#add node data

    method addEdge origin label destination =
      let edge : ('node, 'edge) edge = (origin, label, destination) in
      assert (not (self#isEdgeTuple edge));
      edges#add edge ();
      succs#add origin (label, destination);
      preds#add destination (label, origin)


    method isNode =
      nodes#mem

    method isEdge origin label destination =
      self#isEdgeTuple (origin, label, destination)

    method private isEdgeTuple =
      edges#mem


    method iterNodes =
      nodes#iter


    method succ origin : ('edge * 'node) list =
      assert (self#isNode origin);
      succs#findAll origin

    method pred destination : ('edge * 'node) list =
      assert (self#isNode destination);
      preds#findAll destination
  end
