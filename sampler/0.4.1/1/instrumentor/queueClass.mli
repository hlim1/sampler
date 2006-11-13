class ['element] container :
  object
    method add : 'element -> unit
    method clear : unit
    method iter : ('element -> unit) -> unit
    method fold : ('result -> 'element -> 'result) -> 'result -> 'result
  end
