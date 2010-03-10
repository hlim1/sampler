val matchesOrWildcard : 'b -> 'b -> 'b -> bool


class virtual ['a] filter :
  object
    method addExclude : 'a -> unit
    method addInclude : 'a -> unit

    method private virtual matches : 'a -> 'a -> bool
    method included : 'a -> bool

    method private virtual format : 'a -> Pretty.doc
    method private formatPatterns : string
  end
