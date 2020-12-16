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
	i[5] pass,
	regexp_replace(i[5], '[^' || i[3] || ']', '', 'g') scrub,
	length(regexp_replace(i[5], '[^' || i[3] || ']', '', 'g')) len
from
	passwords
) s
where
	s.len >= low and s.len <= hi
;
