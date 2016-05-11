for $x in doc("books.xml")/bookstore/book
where $x/price>30
return $x/title