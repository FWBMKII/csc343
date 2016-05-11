
let $d := fn:doc("nmb.xml")
return
<both>
<one> {$d//c[d>"t"]} </one>
<two> {$d//c/d[.>"t"]} </two>
</both>
