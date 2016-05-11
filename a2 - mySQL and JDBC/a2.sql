-- Add below your SQL statements. 
-- You can create intermediate views (as needed). Remember to drop these views after you have populated the result tables.
-- You can use the "\i a2.sql" command in psql to execute the SQL commands in this file.
CREATE TABLE Query1(
	c1id	INTEGER,
    c1name	VARCHAR(20),
	c2id	INTEGER,
    c2name	VARCHAR(20)
);

CREATE TABLE Query2(
	cid		INTEGER,
    cname	VARCHAR(20)
);

CREATE TABLE Query3(
	c1id	INTEGER,
    c1name	VARCHAR(20),
	c2id	INTEGER,
    c2name	VARCHAR(20)
);

CREATE TABLE Query4(
	cname	VARCHAR(20),
    oname	VARCHAR(20)
);

CREATE TABLE Query5(
	cid		INTEGER,
    cname	VARCHAR(20),
	avghdi	REAL
);

CREATE TABLE Query6(
	cid		INTEGER,
    cname	VARCHAR(20)
);

CREATE TABLE Query7(
	rid			INTEGER,
    rname		VARCHAR(20),
	followers	INTEGER
);

CREATE TABLE Query8(
	c1name	VARCHAR(20),
    c2name	VARCHAR(20),
	lname	VARCHAR(20)
);

CREATE TABLE Query9(
    cname		VARCHAR(20),
	totalspan	INTEGER
);

CREATE TABLE Query10(
    cname			VARCHAR(20),
	borderslength	INTEGER
);


-- Query 1 statements
INSERT INTO Query1
(select c1id, country.cname as c1name, c2id, c2name
from (select country as c1id, neighbor as c2id, cname as c2name
	  from (neighbour 
			join country
			on neighbor = cid) temp
	  where height = (select max(height)
					   from (neighbour 
							 join country
							 on neighbor = cid) temp2
					   where temp2.country = temp.country)) country_2 , country
where c1id = cid
order by c1name ASC
);


-- Query 2 statements
INSERT INTO Query2
(select country.cid, country.cname
from country,
	 (select cid
	 from country
 	 except
	 select cid
	 from oceanAccess) landlockid
where landlockid.cid = country.cid
order by country.cname ASC
);


-- Query 3 statements
INSERT INTO Query3
(select requiredN2.c1id, requiredN2.c1name, requiredN2.c2id, country.cname as c2name
from country,
	(select requiredN.c1id, country.cname as c1name, requiredN.c2id
	from country,
		(select country as c1id, neighbor as c2id
		from neighbour,
			(select landlock.cid 
			from
				(select country as cid
				from neighbour
				group by cid
				having count(neighbour) = 1) oneneighbor
				,
				(select cid
				from country 
				except
				select cid
				from oceanAccess) landlock
			where oneneighbor.cid = landlock.cid) requiredId
		where neighbour.country = requiredId.cid) requiredN
	where country.cid = requiredN.c1id) requiredN2
where country.cid = requiredN2.c2id
order by requiredN2.c1id ASC
);


-- Query 4 statements
INSERT INTO Query4
((select country.cname, ocean.oname
from oceanAccess, country, ocean
where oceanAccess.cid = country.cid
	and oceanAccess.oid = ocean.oid)
union
(select country.cname, ocean.oname
from country, ocean, 
	(select neighbour.country as cid, oceanAccess.oid
	from neighbour, oceanAccess
	where neighbour.neighbor = oceanAccess.cid) NAccess
where country.cid = NAccess.cid
	AND ocean.oid = NAccess.oid)
order by cname ASC, oname DESC
);


-- Query 5 statements
INSERT INTO Query5
(select ahdi.cid, country.cname, ahdi.avghdi
from country, 
	(select cid, avg(hdi_score) as avghdi
	from
		(select cid, hdi_score
		from hdi
		where year >2008 and year < 2014) hdi_year
	group by cid) ahdi
where country.cid = ahdi.cid
order by avghdi DESC 
limit 10
);


-- Query 6 statements



-- Query 7 statements



-- Query 8 statements



-- Query 9 statements
INSERT INTO Query9
(select *
from (select cid, (height + maxd) as totalspan
	from (select oceanAccess.cid, country.height, max(ocean.depth) as maxd
			from oceanAccess, country, ocean
			where country.cid = oceanAccess.cid
				and ocean.oid = oceanAccess.oid
			group by oceanAccess.cid, country.height) ocountryhd
	union
	(select cid, height as totalspan
	from country
	except 
	select cid, height
	from (select oceanAccess.cid, country.height, max(ocean.depth) as maxd
			from oceanAccess, country, ocean
			where country.cid = oceanAccess.cid
				and ocean.oid = oceanAccess.oid
			group by oceanAccess.cid, country.height) ocountryhd)) ct
where totalspan = (select max(ct.totalspan)
					from country, 
						(select cid, (height + maxd) as totalspan
						from (select oceanAccess.cid, country.height, max(ocean.depth) as maxd
								from oceanAccess, country, ocean
								where country.cid = oceanAccess.cid
									and ocean.oid = oceanAccess.oid
								group by oceanAccess.cid, country.height) ocountryhd
						union
						(select cid, height as totalspan
						from country
						except 
						select cid, height
						from (select oceanAccess.cid, country.height, max(ocean.depth) as maxd
								from oceanAccess, country, ocean
								where country.cid = oceanAccess.cid
									and ocean.oid = oceanAccess.oid
								group by oceanAccess.cid, country.height) ocountryhd)) ct
					where country.cid = ct.cid)
);


-- Query 10 statements


