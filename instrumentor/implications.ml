open Pretty

type data = {id: int; value: int64}

type rel = | Gt of data | Lt of data | Eq of data 

type t = (rel * rel) list list 

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

let analyzeAll l =
  List.fold_left (fun l x -> analyze x::l) [] l 

let printAll digest channel l =   
  let compilationUnit = Digest.to_hex (Lazy.force digest) in
  let scheme = "scalar-pairs" in

  let docImpl r1 r2 =
    let docRel r =
      (text compilationUnit)++
      (chr '\t')++
      (text scheme)++
      (chr '\t')++
      (match r with
        | Lt d -> (num d.id)++(chr '\t')++(num 0)
        | Eq d -> (num d.id)++(chr '\t')++(num 1)
        | Gt d -> (num d.id)++(chr '\t')++(num 2)
      )
    in (docRel r1)++(chr '\t')++(docRel r2) 
  in

  let printPair l r =
    Pretty.fprint channel max_int ((docImpl l r)++line)

  in List.iter (fun x -> List.iter (fun (l,r) -> printPair l r) x) l

class type constantComparisonAccumulator = 
  object 
    method addInspirationInfo : (int * int64) list -> unit
    method getInfos : unit -> (int * int64) list list
  end

class c_impl : constantComparisonAccumulator =
  object (self)
    val inspirationInfos = ref [] 

    method addInspirationInfo (info : (int * int64) list) =  
      inspirationInfos := info :: !inspirationInfos

    method getInfos () = !inspirationInfos

  end



let getAccumulator = new c_impl
