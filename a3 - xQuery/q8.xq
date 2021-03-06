<report>{
for $i in doc("interview.xml")//interview
return <interview>
			<who rID="{data($i/@rID)}"
				 forename="{for $n in doc("resume.xml")//resume[@rID=data($i/@rID)]
							return data($n//forename)}"
				 surname="{for $n in doc("resume.xml")//resume[@rID=data($i/@rID)]
							return data($n//surname)}"></who>
			<position>{
				for $p in doc("posting.xml")//posting[@pID=data($i/@pID)]
				return data($p/position)
			}</position>
			<match>{
				sum(
					let $r := doc("resume.xml")//resume[@rID=data($i/@rID)]
					let $p := doc("posting.xml")//posting[@pID=data($i/@pID)]

					for $pSkill in $p//reqSkill

					return if (exists($r//skill[@what=data($pSkill/@what)]) and $pSkill/@level <= $r//skill[@what=$pSkill/@what]/@level)
						   then(data($pSkill/@importance) * 1)
						   else(data($pSkill/@importance) * -1))
			}</match>
			<average>{
				let $a := count($i//answer)
				let $b := sum($i//answer)
				let $c := exists($i//collegiality)
				let $tp := $i//techProficiency
				let $cm := $i//communication
				let $en := $i//enthusiasm
				let $co := sum($i//collegiality)

				return if ($c)
					   then (($b + $tp + $cm + $en + $co) div ($a + 4))
					   else (($b + $tp + $cm + $en) div ($a + 3))
			}</average>
	   </interview>
}</report>

