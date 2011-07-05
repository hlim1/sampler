double context;


int callee_same(int, int, int, int, int);


int caller_same(int a, int b, int c, int d, int e)
{
  return callee_same(a, b, c, d, e);
}


int callee_before(void *, int, int, int, int, int);


int caller_before(int a, int b, int c, int d, int e)
{
  return callee_before(&context, a, b, c, d, e);
}


int callee_after(int, int, int, int, int, void *);


int caller_after(int a, int b, int c, int d, int e)
{
  return callee_after(a, b, c, d, e, &context);
}
