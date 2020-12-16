with numbers (i) as
	(
		select
			*
		from
			regexp_split_to_table(pg_read_file('/tmp/input'), '\n')  AS t(i)
		where
			i <> ''
	)
select
	n1.i::int * n2.i::int AS answer
from
	numbers n1
join
	numbers n2 on true
where
	 (n1.i::int + n2.i::int) = 2020 
limit 1
;
