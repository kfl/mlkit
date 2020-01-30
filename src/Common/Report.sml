(* Reporting of errors, binding, and so on. Tidier than the stuff
   generated by the pretty-printer.
*)

structure Report: REPORT =
  struct

    datatype Report =
      REPORT2 of Report * Report
    | REPORT of string list

    val null = REPORT nil
    fun line s = REPORT [s]

    infix //
    fun r1 // r2 =
      case (r1,r2)
	of (REPORT nil, _) => r2
	 | (_, REPORT nil) => r1
	 | _ => REPORT2(r1,r2)

    val flatten = foldr (op //) null

    fun indent(i, REPORT lines) =
          REPORT(map (fn x => StringCvt.padLeft #" " i "" ^ x) lines)
      | indent (i, REPORT2(r1,r2)) =
	  REPORT2(indent(i,r1),indent(i,r2))

    fun adjust(i, REPORT []) = REPORT []
      | adjust(i, REPORT (l::lines)) =
	REPORT(if i < 0 then
(*		 (String.truncL (String.size l + i)  l)::lines *)
		 (String.extract (l, ~i, NONE))::lines
	       else
		 (StringCvt.padLeft #" " i "" ^ l)::lines)
      | adjust (i, REPORT2(r1,r2)) = REPORT2(adjust(i, r1),adjust(i, r2))

    (*lines report = the list of lines in report*)
    local fun lines0 (REPORT lines) a = lines @ a
	    | lines0 (REPORT2 (report1, report2)) a =
                lines0 report1 (lines0 report2 a)
    in fun lines report = lines0 report []
    end

    (* Decorate report with a text on the first line and indents on
       the remaining lines. *)
    fun decorate (text, REPORT []) = REPORT [text]
      | decorate (text, report) =
          let
	    val include_text = ref true
	    val space = StringCvt.padLeft #" " (String.size text) ""

	    (* function to apply to each line. *)
	    fun f line = if !include_text then (include_text := false ;
						text ^ line)
			 else space ^ line
	  in
	    REPORT (case lines report of
		      [] => [text]
		    | lines => map f lines)
	  end

    fun println s = print (s ^ "\n")
    fun println' os s = (TextIO.output(os, s ^ "\n"); TextIO.flushOut os)

    fun print(REPORT lines) = (map println lines; ())
      | print(REPORT2(r1,r2)) = (print r1; print r2)

    fun print'(REPORT lines) os = (map (println' os) lines; ())
      | print'(REPORT2(r1,r2)) os = (print' r1 os; print' r2 os)

    exception DeepError of Report
  end
