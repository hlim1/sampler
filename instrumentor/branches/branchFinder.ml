open Cil


class visitor =
  object (self)
    inherit SiteFinder.visitor

    method vstmt stmt =
      begin
	match stmt.skind with
	| If details
	  when self#includedStatement stmt ->
	    ignore (new BranchSite.c stmt details)
	| _ -> ()
      end;
      DoChildren
  end
