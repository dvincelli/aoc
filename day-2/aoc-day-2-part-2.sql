with passwords  (i) as
	(
		select
			regexp_split_to_array(i, '\-|:|\s') 
		from
			regexp_split_to_table(pg_read_file('/tmp/input'), '\n')  AS t(i)
		where
			i <> ''
	)
select * from (
select
	i[1]::int low,
	i[2]::int hi,
	i[3] chr,
	trim(i[5]) pass
from
	passwords
) s
where
(
	(substring(pass from low for 1) = chr and substring(pass from hi for 1) <> chr)
or
	(substring(pass from low for 1) <> chr and substring(pass from hi for 1) = chr)
)
;
