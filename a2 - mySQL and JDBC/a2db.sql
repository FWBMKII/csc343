BEGIN;

DROP SCHEMA IF EXISTS A2 CASCADE;
CREATE SCHEMA A2;
SET search_path TO A2;

SET client_encoding = 'LATIN1';

-- The country table contains all the countries in the world and their facts.
-- 'cid' is the id of the country.
-- 'name' is the name of the country.
-- 'height' is the highest elevation point of the country.
-- 'population' is the population of the country.
CREATE TABLE country (
    cid 		INTEGER 	PRIMARY KEY,
    cname 		VARCHAR(20)	NOT NULL,
    height 		INTEGER 	NOT NULL,
    population	INTEGER 	NOT NULL);
    
-- The language table contains information about the languages and the percentage of the speakers of the language for each country.
-- 'cid' is the id of the country.
-- 'lid' is the id of the language.
-- 'lname' is the name of the language.
-- 'lpercentage' is the percentage of the population in the country who speak the language.
CREATE TABLE language (
    cid 		INTEGER 	REFERENCES country(cid) ON DELETE RESTRICT,
    lid 		INTEGER 	NOT NULL,
    lname 		VARCHAR(20) NOT NULL,
    lpercentage	REAL 		NOT NULL,
	PRIMARY KEY(cid, lid));

-- The religion table contains information about the religions and the percentage of the population in each country that follow the religion.
-- 'cid' is the id of the country.
-- 'rid' is the id of the religion.
-- 'rname' is the name of the religion.
-- 'rpercentage' is the percentage of the population in the country who follows the religion.
CREATE TABLE religion (
    cid 		INTEGER 	REFERENCES country(cid) ON DELETE RESTRICT,
    rid 		INTEGER 	NOT NULL,
    rname 		VARCHAR(20) NOT NULL,
    rpercentage	REAL 		NOT NULL,
	PRIMARY KEY(cid, rid));

-- The hdi table contains the human development index of each country per year. (http://en.wikipedia.org/wiki/Human_Development_Index)
-- 'cid' is the id of the country.
-- 'year' is the year when the hdi score has been estimated.
-- 'hdi_score' is the Human Development Index score of the country that year. It takes values [0, 1] with a larger number representing a higher HDI.
CREATE TABLE hdi (
    cid 		INTEGER 	REFERENCES country(cid) ON DELETE RESTRICT,
    year 		INTEGER 	NOT NULL,
    hdi_score 	REAL 		NOT NULL,
	PRIMARY KEY(cid, year));

-- The ocean table contains information about oceans on the earth.
-- 'oid' is the id of the ocean.
-- 'oname' is the name of the ocean.
-- 'depth' is the depth of the deepest part of the ocean (expressed as a positive integer)
CREATE TABLE ocean (
    oid 		INTEGER 	PRIMARY KEY,
    oname 		VARCHAR(20) NOT NULL,
    depth 		INTEGER 	NOT NULL);

-- The neighbour table provides information about the countries and their neighbours.
-- 'country' refers to the cid of the first country.
-- 'neighbor' refers to the cid of a country that is neighbouring the first country.
-- 'length' is the length of the border between the two neighbouring countries.
-- Note that if A and B are neighbours, then there two tuples are stored in the table to represent that information (A, B) and (B, A). 
CREATE TABLE neighbour (
    country 	INTEGER 	REFERENCES country(cid) ON DELETE RESTRICT,
    neighbor 	INTEGER 	REFERENCES country(cid) ON DELETE RESTRICT, 
    length 		INTEGER 	NOT NULL,
	PRIMARY KEY(country, neighbor));

-- The oceanAccess table provides information about the countries which have a border with an ocean.
-- 'cid' refers to the cid of the country.
-- 'oid' refers to the oid of the ocean.
CREATE TABLE oceanAccess (
    cid 	INTEGER 	REFERENCES country(cid) ON DELETE RESTRICT,
    oid 	INTEGER 	REFERENCES ocean(oid) ON DELETE RESTRICT, 
    PRIMARY KEY(cid, oid));


COPY country (cid, cname, height, population) FROM stdin;
1	Arathor	10	1200
2	Alterac	10	0
3	Stormwind	20	200000
4	Dalaran	200	3000
5	Gilneas	30	1600
6	Kul_Tiras	0	10000
7	Lordaeron	30	250000
8	Andorhal	5	0
\.

COPY language (cid, lid, lname, lpercentage) FROM stdin;
1	1	Common	100
3	1	Common	75
3	2	Dwarvish	20
3	3	Darnassian	5
4	1	Common	67.5
4	4	Thalassian	32.5
5	1	Common	50
5	3	Darnassian	50
6	1	Common	100
7	5	Gutterspeak	100
\.

COPY religion (cid, rid, rname, rpercentage) FROM stdin;
3	1	Holy_Light	80
3	2	Druidism	2.5
3	3	Elune	2.5
5	2	Druidism	20
6	1	Arathor	100
7	4	Shadow	90
\.


COPY hdi (cid, year, hdi_score) FROM stdin;
1	1999	0.6
1	2010	0.31
1	2012	0.2
2	1998	0.2
2	2009	0.0
3	2008	0.66
3	2009	0.86
3	2011	0.87
3	2012	0.73
3	2013	0.9
4	2000	0.87
4	2009	0.62
4	2011	1.0
5	2013	0.4
6	2013	0.5
7	2012	0.7
7	2019	1.0
8	2005	0.0
\.

COPY ocean (oid, oname, depth) FROM stdin;
1	Blood_Sea	20000
2	Coral_Sea	100
3	Forbidding_Sea	12000
4	Frozen_Sea	14000
5	Great_Sea	13000
6	North_Sea	6000
7	South_Seas	18000
8	Veiled_Sea	7000
\.

COPY neighbour (country, neighbor, length) FROM stdin;
1	2	800
1	3	3700
1	8	850
2	1	800
2	7	600
2	5	1800
3	1	3700
5	2	1800
5	7	1000
7	2	600
7	5	1000
8	1	850
\.

COPY oceanAccess (cid, oid) FROM stdin;
3	5
5	5
6	5
6	7
\.

COMMIT;
