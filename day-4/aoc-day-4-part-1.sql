select
	count(*)
from
	regexp_split_to_table(pg_read_file('/tmp/input'), '^\n', 'n') as record
where
	record like '%byr%'
and	record like '%iyr%'
and 	record like '%eyr%'
and 	record like '%hgt%'
and 	record like '%hcl%'
and 	record like '%ecl%'
and 	record like '%pid%'
;
