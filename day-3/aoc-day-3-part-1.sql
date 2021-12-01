CREATE OR REPLACE FUNCTION slope(dx int, dy int, maxY int) RETURNS TABLE(x int, y int)
    AS $$ 
	WITH RECURSIVE s(x,y) AS (
		SELECT 1,1
		UNION ALL
		SELECT x+dx, y+dy FROM s WHERE y <= maxY
	)
        SELECT x,y FROM s
    $$
    LANGUAGE SQL;
;

WITH
   frame (i) AS (
	SELECT * FROM regexp_split_to_table(pg_read_file('/tmp/input'), '\n') AS t(i)
),
   map AS (
	SELECT row_number() OVER () AS y, repeat(i, 200) line FROM frame -- 200 is just a guess
), sums AS (
SELECT 
	SUM(CASE substring(m.line FROM s1.x FOR 1) WHEN '#' THEN 1 ELSE 0 END) sum1,
	SUM(CASE substring(m.line FROM s2.x FOR 1) WHEN '#' THEN 1 ELSE 0 END) sum2,
	SUM(CASE substring(m.line FROM s3.x FOR 1) WHEN '#' THEN 1 ELSE 0 END) sum3,
	SUM(CASE substring(m.line FROM s4.x FOR 1) WHEN '#' THEN 1 ELSE 0 END) sum4,
	SUM(CASE substring(m.line FROM s5.x FOR 1) WHEN '#' THEN 1 ELSE 0 END) sum5
FROM
	map m
LEFT JOIN
	slope(1,1,324) s1 on m.y = s1.y
LEFT JOIN
	slope(3,1,324) s2 on m.y = s2.y
LEFT JOIN
	slope(5,1,324) s3 on m.y = s3.y
LEFT JOIN
	slope(7,1,324) s4 on m.y = s4.y
lEFT JOIN
	slope(1,2,324) s5 on m.y = s5.y
)
SELECT sums.sum1 * sums.sum2 * sums.sum3 * sums.sum4 * sums.sum5 FROM sums
;
DROP FUNCTION slope(int,int);
