-- byr (Birth Year) - four digits; at least 1920 and at most 2002. 
-- iyr (Issue Year) - four digits; at least 2010 and at most 2020. -- (201[0-9])|(2020)
-- eyr (Expiration Year) - four digits; at least 2020 and at most 2030. (202[0-9])|(2030) 
-- hgt (Height) - a number followed by either cm or in:
--    If cm, the number must be at least 150 and at most 193. ((1[5-8][0-9])|(19[0-3])cm)
--    If in, the number must be at least 59 and at most 76. ((59)|(6[0-9])|(7[0-6])in)
-- hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f. (\#[a-f0-9]{6})
-- ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth. (amb|blu|brn|gry|grn|hzl|oth)
-- pid (Passport ID) - a nine-digit number, including leading zeroes. \d{9}
-- cid (Country ID) - ignored, missing or not.

CREATE OR REPLACE FUNCTION valid_fields(fields text[])
RETURNS bool
AS
$$
DECLARE
  fieldIndex int;
  fieldValue text;
  scratchInt int;
  matches text[];
BEGIN
  FOR i IN array_lower(fields,1)..(array_upper(fields,1)-1) LOOP
    IF i % 2 = 0 THEN
       CONTINUE;
    END IF;

    fieldIndex := i;
    fieldValue := fields[fieldIndex+1];

    CASE fields[fieldIndex]
      WHEN 'byr' THEN
        IF cast(fieldValue as integer) < 1920 OR cast(fieldValue as integer) > 2002 THEN
          RETURN FALSE;
        END IF;
      WHEN 'iyr' THEN
        IF cast(fieldValue as integer) < 2010 OR cast(fieldValue as integer) > 2020 THEN
          RETURN FALSE;
        END IF;
      WHEN 'eyr' THEN
        IF cast(fieldValue as integer) < 2020 OR cast(fieldValue as integer) > 2030 THEN
          RETURN FALSE;
        END IF;
      WHEN 'hgt' THEN
        BEGIN
        scratchInt := cast(replace(replace(fieldValue, 'cm', ''), 'in', '') as integer);
        IF fieldValue LIKE '%in' AND (scratchInt < 59 OR scratchInt > 76) THEN
             RETURN FALSE;
        END IF; -- in
        IF fieldValue LIKE '%cm' AND (scratchInt < 150 OR scratchInt > 193) THEN
             RETURN FALSE;
        END IF;
        IF fieldValue NOT LIKE '%cm' AND fieldValue NOT LIKE '%in' THEN
             RETURN FALSE;
        END IF;
        END;
      WHEN 'hcl' THEN
          SELECT regexp_match(fieldValue, '^(#[0-9a-f]{6})$') into matches;
          IF array_length(matches, 1) IS NULL THEN
             RETURN FALSE;
          END IF; -- hcl
      WHEN 'ecl' THEN
	  SELECT regexp_match(fieldValue, '^(amb|blu|brn|gry|hzl|oth)$') into matches;
          IF array_length(matches, 1) IS NULL THEN
             RETURN FALSE;
          END IF; -- ecl
      WHEN 'pid' THEN
          SELECT regexp_match(fieldValue, '^([0-9]{9})$') into matches;
          IF array_length(matches, 1) IS NULL THEN
             RETURN FALSE;
          END IF;
      ELSE
          RETURN FALSE;
    END CASE;
  END LOOP;
  RETURN TRUE;
EXCEPTION WHEN invalid_text_representation THEN
   RETURN FALSE;
END;
$$
LANGUAGE plpgsql
STABLE RETURNS NULL ON NULL INPUT;




with raw_records(record) as (
select
	record
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
),
records AS (
	SELECT regexp_split_to_array(record, ':|\s') fields from raw_records
)
-- SELECT * FROM records LIMIT 1;
-- SELECT COUNT(*) FROM records r WHERE valid_fields(r.fields);
SELECT * FROM records r WHERE valid_fields(r.fields);
