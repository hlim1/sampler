open Unix


let rec get suffix =
  let filename, channel = Filename.open_temp_file "bfe-" suffix in
  at_exit (fun () -> unlink filename);
  filename, descr_of_out_channel channel
