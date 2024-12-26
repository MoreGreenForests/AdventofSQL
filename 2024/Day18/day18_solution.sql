-- SKills: Recursive CTE, cardinality, window function, aggregate

with recursive manager as (
  select staff_id, staff_name, manager_id, array[]::integer[] as manager_ids
  from staff
  where manager_id is null
  union all
  select s.staff_id, s.staff_name, s.manager_id, m.manager_ids || m.staff_id as manager_ids
  from staff s
  inner join manager m
  on m.staff_id = s.manager_id
),
paths as (
  select *, manager_ids || staff_id as "path"
  from manager
),
peers as (
  select
    *,
    cardinality("path") as "level",
    count(*) over (partition by manager_id) as peers_same_manager,
    count(*) over (partition by cardinality("path")) as total_peers_same_level
  from paths
)
select staff_id, staff_name, "level", "path", manager_id, peers_same_manager, total_peers_same_level
from peers
order by total_peers_same_level desc, staff_id
fetch first 20 rows only;