type data = {id: int; value: int64}

type rel = | Gt of data | Lt of data | Eq of data 

class type c_type =
  object
    method print : unit
  end

class c_internal data = 
  object (self)
    val impl_pairs = data 

    method private print_rel rel =
      match rel with 
        | Gt d -> prerr_string ("Gt "); prerr_string "value: "; prerr_string (Int64.to_string d.value); prerr_string " at site "; prerr_int d.id 
        | Lt d -> prerr_string ("Lt "); prerr_string "value: "; prerr_string (Int64.to_string d.value); prerr_string " at site "; prerr_int d.id
        | Eq d -> prerr_string ("Eq "); prerr_string "value: "; prerr_string (Int64.to_string d.value); prerr_string " at site "; prerr_int d.id
      
    method print = 
      List.iter (fun (l, r) -> self#print_rel l; prerr_string " -> "; self#print_rel r; prerr_newline () ) impl_pairs  
  end

class c_impl d = (c_internal d : c_type)

let deriveImplications (lid, ln) (rid, rn) = 
  let res = Int64.compare ln rn in
  let l = {id = lid; value = ln} in
  let r = {id = rid; value = rn} in
    if res > 0 then 
      [(Gt l, Gt r); (Lt r, Lt l); (Eq l, Gt r); (Eq r, Lt l)] 
    else if res < 0 then 
      [(Gt r, Gt l); (Lt l, Lt r); (Eq r, Gt l); (Eq l, Lt r)] 
    else 
      [(Gt r, Gt l); (Gt l, Gt r); (Lt r, Lt l); (Lt l, Lt r); (Eq r, Eq l); (Eq l, Eq r)] 


let analyze l =
let impl_list = ref [] in
let rec process l = 
let action l r  =
  List.iter (fun e -> impl_list := e :: !impl_list) (deriveImplications l r) 
in
  match l with
    | [] -> ()
    | hd :: tl -> List.iter (action hd) tl; process tl 
in
  process l;
  !impl_list

let debug = true

let makeImplications l =
  if debug then
      prerr_string "Building implications....\n";
  new c_impl (analyze l) 
