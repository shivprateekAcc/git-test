--Created By Shiv Prateek Sharma
-- To support critical Prod Sanity and find WF and Task deplyment mismatch
--Repository Mismatch 

--WF Miss
select proc_name, STATUS_CD, version, w.CREATED from siebel.S_WFR_PROC w , SIEBEL.S_REPOSITORY r
where (r.INACTIVE_FLG is null or r.INACTIVE_FLG = 'N') and w.REPOSITORY_ID=r.row_id and w.STATUS_CD='COMPLETED'
and not exists
(select 1 from siebel.S_WFA_DPLOY_DEF d where type_cd='PROCESS' and d.DEPLOY_STATUS_CD='ACTIVE' and d.name=w.PROC_NAME)
order by w.CREATED desc;
--WF Version Mismatch
select w.proc_name, w.STATUS_CD, w.version,d.REPOSITORY_VERSION as DEPVER, w.CREATED from siebel.S_WFR_PROC w , SIEBEL.S_REPOSITORY r,siebel.S_WFA_DPLOY_DEF d
where (r.INACTIVE_FLG is null or r.INACTIVE_FLG = 'N') and w.REPOSITORY_ID=r.row_id and w.STATUS_CD='COMPLETED'
and d.type_cd='PROCESS' and d.DEPLOY_STATUS_CD='ACTIVE' and d.name=w.PROC_NAME and w.LAST_UPD > sysdate-90
and w.VERSION != d.REPOSITORY_VERSION;
--Task version Mismatch
select t.task_name,t.version , d.REPOSITORY_VERSION from siebel.S_TU_TASK t , SIEBEL.S_REPOSITORY r, siebel.S_WFA_DPLOY_DEF d
where (r.INACTIVE_FLG is null or r.INACTIVE_FLG = 'N') and t.REPOSITORY_ID=r.row_id and t.STATUS_CD='COMPLETED'
and d.type_cd='TASK' and d.DEPLOY_STATUS_CD='ACTIVE' and d.name=t.TASK_NAME and t.LAST_UPD > sysdate-90
and t.VERSION != d.REPOSITORY_VERSION;
--TASK Mismatch
select w.task_name, w.STATUS_CD, w.version, w.CREATED from siebel.S_TU_TASK w , SIEBEL.S_REPOSITORY r
where (r.INACTIVE_FLG is null or r.INACTIVE_FLG = 'N') and w.REPOSITORY_ID=r.row_id and w.STATUS_CD='COMPLETED'
and not exists
(select 1 from siebel.S_WFA_DPLOY_DEF d where type_cd='TASK' and d.DEPLOY_STATUS_CD='ACTIVE' and d.name=w.TASK_NAME)
order by w.CREATED desc;

--HIGH IMPACT DB Analysis
--Cant be executed with readonly user 

--High execution SQL 
select * from (
select ROWS_PROCESSED, USER_IO_WAIT_TIME, EXECUTIONS,SQL_FULLTEXT,SQL_ID
from v$sql where TO_DATE (first_LOAD_TIME,'YYYY-MM-DD/HH24:MI:SS') > sysdate -2       
order by EXECUTIONS desc) b where rownum < 11 order by EXECUTIONS desc;
--FTS Query or high load Query
select * from (
select ROWS_PROCESSED, USER_IO_WAIT_TIME, EXECUTIONS,SQL_FULLTEXT,SQL_ID
from v$sql where TO_DATE (first_LOAD_TIME,'YYYY-MM-DD/HH24:MI:SS') > sysdate -2       
order by ROWS_PROCESSED desc) b where rownum < 11 order by ROWS_PROCESSED desc;
--HIGH IMPACT QUERY
select * from (
select ROWS_PROCESSED, USER_IO_WAIT_TIME, EXECUTIONS,SQL_FULLTEXT,SQL_ID
from v$sql where TO_DATE (first_LOAD_TIME,'YYYY-MM-DD/HH24:MI:SS') > sysdate -2       
order by USER_IO_WAIT_TIME desc) b where rownum < 11 order by USER_IO_WAIT_TIME desc;

