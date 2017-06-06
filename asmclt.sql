set pages 1000
set term off
col mp new_value pname
col gp new_value gname
select 'a'||max(length(name)) gp from v$asm_diskgroup;

set term on

col groupname form &gname heading "Group Name"
col block_size form 9999 heading "Block|Size"
col au form 999 heading "AU"
col inm format a10 heading "Instance"
col dbn format a10 heading "DB Name"
col sv  format a10 heading "Oracle Ver"

set lines 150

break on groupname on dbn on sv on block_size on state on inm

spool asmclt.log

SELECT  g.name groupname,
        c.db_name dbn,
        c.software_version sv,
        g.block_size,
        g.state,
        c.instance_name inm
FROM    gv$asm_diskgroup g,
        gv$asm_client c
WHERE   c.group_number = g.group_number
  and   g.inst_id = c.inst_id
ORDER BY g.name
/

spool off

clear breaks