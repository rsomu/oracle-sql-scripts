col file_name form a45    heading "Filename"
col tablespace_name form a13  heading "Tablespace"
col sizemb form 999,999.9 heading "Size|(GB)"
col used form 999,999.9   heading "Used|(GB)"
col pct form 999.9    heading "Pct|Used"

clear breaks
compute sum of sizemb used on report
break on report skip 1

spool fnames.log

SELECT /*+ all_rows use_concat */
  (CASE
    WHEN LENGTH(ddf.file_name) < 46 THEN ddf.file_name
    ELSE SUBSTR(ddf.file_name, 1, 42)||'...'
    END
  ) file_name,
  ddf.tablespace_name,
  --- vdf.status,
  NVL(ddf.bytes/1024/1024/1024, 0) sizemb,
  DECODE(ts.contents, 'UNDO',
    NVL(NVL(u.bytes,0)/1024/1024/1024, 0),
    NVL((ddf.bytes-NVL(s.bytes, 0))/1024/1024/1024, 0)) used,
  DECODE(ts.contents, 'UNDO',
    NVL(NVL(u.bytes, 0) / ddf.bytes * 100, 0),
    NVL((ddf.bytes - NVL(s.bytes, 0)) / ddf.bytes * 100, 0)) pct
FROM  sys.dba_data_files ddf,
  v$datafile vdf,
  sys.dba_tablespaces ts,
  ( SELECT  file_id, SUM(bytes) bytes
    FROM  sys.dba_free_space GROUP BY file_id) s,
  ( SELECT  file_id, SUM(bytes) bytes
    FROM  sys.dba_undo_extents
    WHERE status IN ('ACTIVE','UNEXPIRED')
    GROUP BY file_id) u
WHERE (
    ddf.file_id= vdf.file#
and   ddf.file_id = s.file_id(+)
and   ddf.file_id=u.file_id(+)
and   ddf.tablespace_name = ts.tablespace_name)
UNION ALL
SELECT  dtf.file_name,
  dtf.tablespace_name,
  --- vtf.status,
  NVL(dtf.bytes/1024/1024/1024, 0) sizemb,
  NVL(t.bytes_cached/1024/1024/1024, 0) used,
  NVL(t.bytes_cached / dtf.bytes * 100, 0) pct
FROM  sys.dba_temp_files dtf,
  v$tempfile vtf,
  v$temp_extent_pool t
WHERE dtf.file_id = vtf.file#
AND dtf.file_id = t.file_id(+)
ORDER BY file_name, tablespace_name
/


col name format a70

select name from v$controlfile;

col member format a50
col sz format 999,999.99 heading 'Log Size'
select l.thread#, l.group#, l.bytes/1024/1024/1024 sz, l.status, f.member
  from v$log l, v$logfile f
 where l.group# = f.group#
 order by 1,2;

spool off

clear breaks