open Cil


type logger = exp

type loggers = {
  pointer : logger;

  double : logger;
  longDouble : logger;

  char : logger;

  short : logger;
  unsignedShort : logger;

  int : logger;
  unsignedInt : logger;

  long : logger;
  unsignedLong : logger;

  longLong : logger;
  unsignedLongLong : logger
}
