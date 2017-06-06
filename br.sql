rem 
rem br.sql - Backup Report
rem 
rem SQL to report all the RMAN backup jobs
rem
set lines 90
col INPUT_BYTES_DISPLAY format a10
col OUTPUT_BYTES_DISPLAY format a10
col INPUT_BYTES_PER_SEC_DISPLAY format a10 heading 'In Bps'
col OUTPUT_BYTES_PER_SEC_DISPLAY format a10 heading 'Out Bps'
col TIME_TAKEN_DISPLAY format a10 heading 'Elapsed'
select start_time, INPUT_BYTES_DISPLAY, OUTPUT_BYTES_DISPLAY, INPUT_BYTES_PER_SEC_DISPLAY,
       OUTPUT_BYTES_PER_SEC_DISPLAY, TIME_TAKEN_DISPLAY
 from v$rman_backup_job_details;
