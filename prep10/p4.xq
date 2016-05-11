for $c in doc("property.xml")/PROPERTIES/PROPERTY/COMMERCIAL
where $c/@sqft > 1000
return $c/@sqft
