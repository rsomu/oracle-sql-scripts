set pages 1000
set term off
col mp new_value pname
col dp new_value dname
col gp new_value gname
select 'a'||max(length(path)) mp, 'a'||max(length(name)) dp from v$asm_disk;
select 'a'||max(length(name)) gp from v$asm_diskgroup;

set term on

col path form &pname heading "Path"
col diskname form &dname heading "Disk Name"
col groupname form &gname heading "Group Name"
col sector_size form 99999 heading "Sector|Size"
col block_size form 9999 heading "Block|Size"
col total_gig form 9,999,999 heading "Group|Total|GB"
col free_gig form 9,999,999 heading "Group|Free|GB"
col dtotal_gig form 9,999,999 heading "Disk|Total|GB"
col dfree_gig form 9,999,999 heading "Disk|Free|GB"
col au form 999 heading "AU"
col failgroup format a15 heading 'Fail Group'

set lines 150

break on groupname on total_gig on free_gig skip 1

SELECT  g.name groupname,
        d.path,
        d.name diskname,
        g.block_size,
        g.allocation_unit_size/1024/1024 au,
        g.state
FROM    v$asm_diskgroup g,
        v$asm_disk d
WHERE   d.group_number = g.group_number
ORDER BY g.name, d.disk_number;

clear breaks