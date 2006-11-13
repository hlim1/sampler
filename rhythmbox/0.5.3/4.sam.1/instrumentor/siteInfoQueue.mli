class container :
  object
    inherit [SiteInfo.t] QueueClass.container

    method serialize : Digest.t -> string
  end
