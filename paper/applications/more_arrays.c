void
more_arrays ()
{
  int indx;
  int old_count;
  bc_var_array **old_ary;
  char **old_names;

  /* Save the old values. */
  old_count = a_count;
  old_ary = arrays;
  old_names = a_names;

  /* Increment by a fixed amount and allocate. */
  a_count += STORE_INCR;
  arrays = (bc_var_array **) bc_malloc (a_count*si...
  a_names = (char **) bc_malloc (a_count*sizeof(ch...

  /* Copy the old arrays. */
  for (indx = 1; indx < old_count; indx++)
    arrays[indx] = old_ary[indx];


  /* Initialize the new elements. */
  for (; indx < v_count; indx++)
    arrays[indx] = NULL;

  /* Free the old elements. */
  if (old_count != 0)
    {
      free (old_ary);
      free (old_names);
    }
}
