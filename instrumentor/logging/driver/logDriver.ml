open Filename


class c homeDir instrumentor compiler arguments =
  object (self)
    inherit InstDriver.c homeDir instrumentor compiler arguments as super

    method private extraHeader = homeDir ^ "/liblog/log.h"

    method private extraLibs =
      let dir = homeDir ^ "/liblog" in
      ("-Wl,-rpath," ^ dir) :: ("-L" ^ dir) :: "-llog" :: super#extraLibs
  end
