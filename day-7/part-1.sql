with ruleset (rule_id, rules) as
  (
    select
      row_number() over() as rule_id,
      regexp_matches(rule, '([0-9]*) ?([a-z ]+) bags', 'g') as rules
    from
      regexp_split_to_table(pg_read_file('/tmp/input'), '\n', 'n') AS t(rule)
  ),
terminal_rules (rule_id, rules) as
  (
    select
    	rule_id,
	rules
    from
    	ruleset
    where
    	rules[2]
    like '%shiny gold%' and rules[1] <> ''
  ),
direct_rules (rule_id, rules) as (
  select
  	rs.rule_id, rs.rules
  from
  	ruleset rs 
  join
  	terminal_rules t
  on rs.rule_id = t.rule_id
)
select * from
	ruleset rs join
	direct_rules dr on dr.rules[2] = rs.rules[2] and dr.rule_id != rs.rule_id
;

