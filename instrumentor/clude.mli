type disposition = Include | Exclude

type pattern


val register : flag:string -> desc:string -> ident:string -> pattern list ref -> unit

val filter : pattern list -> string -> disposition
