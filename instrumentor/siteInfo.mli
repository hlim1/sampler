open Cil


type t = { location : location;
	   fundec : fundec;
	   statement : stmt;
	   description : Pretty.doc }
