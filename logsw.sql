col day format a15;
col hour format a4;
col total format 999;
spool logsw.log
select to_char(first_time,'YYYY-MM-DD') day,
to_char(first_time,'HH24') hour,
count(*) total
from v$log_history
group by to_char(first_time,'YYYY-MM-DD'),to_char(first_time,'HH24')
order by to_char(first_time,'YYYY-MM-DD'),to_char(first_time,'HH24')
asc;
spool off