#ifndef INCLUDE_sampler_embeded_cfg_h
#define INCLUDE_sampler_embeded_cfg_h


struct __CFG_func {
  const char * const name;
  const unsigned nodeCount;
  const struct __CFG_node * const nodes;
  const unsigned flowCount;
  const struct __CFG_flow * const flows;
  const unsigned callCount;
  const struct __CFG_call * const calls;
};


struct __CFG_node {
  const char *file;
  unsigned line;
};


struct __CFG_flow {
  unsigned start;
  unsigned finish;
};


struct __CFG_call {
  unsigned caller;
  const struct __CFG_func *callee;
};


#endif /* !INCLUDE_sampler_embeded_cfg_h */
