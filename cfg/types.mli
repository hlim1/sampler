type linkage = Static | External

type ('a, 'b) link = Raw of 'a | Resolved of 'b


type callees = Unknown | Known of (string, func) link ref list

and node = {
    mutable nid : int;
    location : Location.t;
    mutable successors : (int, node) link ref list;
    mutable callees : callees;
  }

and func = {
    mutable fid : int;
    linkage : linkage;
    name : string;
    start : Location.t;
    nodes : node array;
  }

and compilation = {
    sourceName : string;
    signature : string;
    functions : func list;
  }

and obj = {
    objectName : string;
    compilations : compilation list;
  }


type symtab = func StringMap.M.t

type environment = { locals : symtab; globals : symtab }
