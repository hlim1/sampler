type linkage = Static | External

type ('a, 'b) link = Raw of 'a | Resolved of 'b


type callees = (string, func) link list Known.known

and node = {
    nid : int;
    location : Location.t;
    mutable parent : func;
    mutable successors : node list;
    mutable callees : callees;
    mutable visited : ClockMark.t;
  }

and func = {
    fid : int;
    linkage : linkage;
    name : string;
    start : Location.t;
    nodes : node array;
    mutable callers : node list;
    returns : node list;
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
