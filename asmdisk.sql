rem
rem asmdisk.sql
rem 
set pages 100
set lines 132
col path format a30
col tg format 999,999.99 heading 'Total GB'
col fg format 999,999.99 heading 'Free GB'
select disk_number, header_status, total_mb/1024 tg, free_mb/1024 fg, path from v$asm_disk
 order by group_number, disk_number
/