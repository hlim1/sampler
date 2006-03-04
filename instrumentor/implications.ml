type rel = | Gt of int | Lt of int | Eq of int 

class type c_type =
  object
    method print : unit
  end

class c_internal data = 
  object
    val impl_pairs = data 

    method print = 
      let print_rel rel =
        match rel with 
          | Gt v -> prerr_string ("Gt "); prerr_int v 
          | Lt v -> prerr_string ("Lt "); prerr_int v
          | Eq v -> prerr_string ("Eq "); prerr_int v
      in 
      List.iter (fun (l, r) -> print_rel l; prerr_string " -> "; print_rel r; prerr_newline () ) impl_pairs  
  end

class c_impl d = (c_internal d : c_type)

let deriveImplications (lid, ln) (rid, rn) = 
  let res = Pervasives.compare ln rn in
    if res > 0 then 
      [(Gt lid, Gt rid); (Lt rid, Lt lid); (Eq lid, Gt rid); (Eq rid, Lt lid)] 
    else if res < 0 then 
      [(Gt rid, Gt lid); (Lt lid, Lt rid); (Eq rid, Gt lid); (Eq lid, Lt rid)] 
    else 
      [ (Gt rid, Gt lid); (Gt lid, Gt rid); (Lt rid, Lt lid); (Lt lid, Lt rid); (Eq rid, Eq lid); (Eq lid, Eq rid)] 


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

let makeImplications l =
  new c_impl (analyze l) 
