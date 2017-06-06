set lines 110
col name format a40
col value format a60
spool params.log
select name, value from v$parameter
 where value is not null;
spool off