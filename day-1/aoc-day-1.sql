with numbers (i) as
	(
		select
			i::int
		from
			regexp_split_to_table(pg_read_file('/tmp/input'), '\n')  AS t(i)
		where
			i <> ''
	)
select
	n1.i * n2.i AS answer
from
	numbers n1
join
	numbers n2 on true
where
	 (n1.i + n2.i) = 2020 
limit 1
;
