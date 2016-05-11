let $output :=
for $r in doc("property.xml")/PROPERTIES/PROPERTY/RESIDENTIAL
	for $i in $r//INFO[RENT_AMOUNT<800]/RENT_AMOUNT
	return  <DEAL>{data($i)}</DEAL>
return <DEALS>{$output}</DEALS>