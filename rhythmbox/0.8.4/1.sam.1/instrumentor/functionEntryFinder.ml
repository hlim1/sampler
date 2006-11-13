open Cil


class visitor (counters : Counters.manager) =
  object (self)
    inherit SiteFinder.visitor

    method vfunc func =
      begin
	if self#includedFunction func then
	  let body = func.sbody in
	  let bump = counters#addSite func NoOffset Pretty.nil func.svar.vdecl in
	  body.bstmts <- bump :: body.bstmts
      end;
      SkipChildren
  end
