<skills>
{
for $ps in (distinct-values(
	for $req1 in doc("posting.xml")/postings/posting/reqSkill
	return data($req1/@what)))
return <skill name="{data($ps)}">
	   		<count level="1" n="{count(
				for $s in doc("resume.xml")/resumes/resume/skills/skill
				where $s/@what=data($ps) and $s/@level="1"
				return $s)}"></count>
	   		<count level="2" n="{count(
				for $s in doc("resume.xml")/resumes/resume/skills/skill
				where $s/@what=data($ps) and $s/@level="2"
				return $s)}"></count>
	   		<count level="3" n="{count(
				for $s in doc("resume.xml")/resumes/resume/skills/skill
				where $s/@what=data($ps) and $s/@level="3"
				return $s)}"></count>
	   		<count level="4" n="{count(
				for $s in doc("resume.xml")/resumes/resume/skills/skill
				where $s/@what=data($ps) and $s/@level="4"
				return $s)}"></count>
	   		<count level="5" n="{count(
				for $s in doc("resume.xml")/resumes/resume/skills/skill
				where $s/@what=data($ps) and $s/@level="5"
				return $s)}"></count>
	   </skill>
}
</skills>
