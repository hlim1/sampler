open Cil
open Foreach


class dominatorTree idom = object(self)
    
  method idom (node : stmt) : stmt option =
    try Some(idom#find node)
    with Not_found -> None

  method dominates ancestor descendant =
    if ancestor == descendant then
      true
    else
      self#strictlyDominates ancestor descendant

  method strictlyDominates ancestor descendant =
    match self#idom descendant with
    | Some(idom) -> self#dominates ancestor idom
    | None -> false
end


let computeDominators (r, nodes) =
  let n0 = dummyStmt in
  let newMap _ = new StmtMap.container in
  
  let bucket = newMap ()
  and sdno = newMap ()
  and size = newMap ()
  and ancestor = newMap ()
  and label = newMap ()
  and ndfs = new IntMap.container
  and child = newMap ()
  and parent = newMap ()
  and idom = newMap ()
  in

  foreach nodes begin
    fun node ->
      bucket#add node new StmtSet.container;
      sdno#add node 0
  end;
  
  size#add n0 0;
  sdno#add n0 0;
  ancestor#add n0 n0;
  label#add n0 n0;
    
  let n = ref 0 in
  let rec depthFirstSearch v =
    incr n;
    sdno#replace v !n;
    ndfs#add !n v;
    label#add v v;
    ancestor#add v n0;
    child#add v n0;
    size#add v 1;

    foreach v.succs begin
      fun w ->
	if sdno#find w == 0 then
	  begin
	    parent#add w v;
	    depthFirstSearch w
	  end
    end
  in
  depthFirstSearch r;

  let rec compress v =
    if ancestor#find (ancestor#find v) != n0 then
      begin
	compress (ancestor#find v);
	if sdno#find (label#find (ancestor#find v)) < sdno#find (label#find v) then
	  label#replace v (label#find (ancestor#find v));
	ancestor#replace v (ancestor#find (ancestor#find v))
      end
  in
	
  let eval v =
    if ancestor#find v == n0 then
      label#find v
    else
      begin
	compress v;
	if sdno#find (label#find (ancestor#find v)) >= sdno#find (label#find v) then
	  label#find v
	else
	  label#find (ancestor#find v)
      end
  in
  
  let link v w =
    let s = ref w in
    while sdno#find (label#find w) < sdno#find (label#find (child#find !s)) do
      if size#find !s + size#find (child#find (child#find !s)) >= 2* size#find (child#find !s) then
	begin
	  ancestor#replace (child#find !s) !s;
	  child#replace !s (child#find (child#find !s));
	end
      else
	begin
	  size#replace (child#find !s) (size#find !s);
	  ancestor#replace !s (child#find !s);
	  s := child#find !s
	end
    done;
    
    label#replace !s (label#find w);
    size#replace v (size#find v + size#find w);
    if size#find v < 2 * size#find w then
      begin
	let tmp = !s in
	s := child#find v;
	child#replace v tmp
      end;
    
    while !s != n0 do
      ancestor#replace !s v;
      s := child#find !s
    done
  in

  for i = !n downto 2 do
    let w = ndfs#find i in
    foreach w.preds begin
      fun v ->
	let u = eval v in
	if sdno#find u < sdno#find w then
	  sdno#replace w (sdno#find u)
    end;

    (bucket#find (ndfs#find (sdno#find w)))#add w;
    link (parent#find w) w;

    while not (bucket#find (parent#find w))#isEmpty do
      let v = (bucket#find (parent#find w))#choose in
      (bucket#find (parent#find w))#remove v;
      let u = eval v in
      if sdno#find u < sdno#find v then
	idom#add v u
      else
	idom#add v (parent#find w)
    done
  done;

  for i = 2 to !n do
    let w = ndfs#find i in
    if idom#find w != ndfs#find (sdno#find w) then
      idom#replace w (idom#find (idom#find w))
  done;

  new dominatorTree idom
