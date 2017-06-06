set pages 100
set lines 100
col opname format a30
select inst_id, opname, start_time, last_update_time, elapsed_seconds,  message from gv$session_longops