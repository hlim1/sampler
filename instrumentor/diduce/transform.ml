open Cil
open Mapconcat


class visitor =
  object
    inherit SkipVisitor.visitor

    method vglob global =
      match global with
      | GFun (fundec, _) ->

	  let trackers = ref [] in
	  let newTracker scope typ =
	    let tracker = new Tracker.tracker fundec scope typ in
	    trackers := tracker :: !trackers;
	    tracker
	  in

	  Returns.transform fundec newTracker;
	  Formals.transform fundec newTracker;

	  if !trackers == [] then
	    SkipChildren
	  else
	    ChangeTo (mapconcat (fun tracker -> tracker#define) [global] !trackers)

      | _ ->
	  SkipChildren
  end


let phase =
  "Transform",
  visitCilFile (new visitor)
