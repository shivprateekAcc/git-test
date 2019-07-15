#Log File Analyzer V3.0 
#Owner Shiv Prateek Sharma
#Created 20/July/2016 
#Code will create 4 file for WF timing ,SQL timings
#,Web-Service Call Timings & Business Service timings
 
# V2 Added support for Multiple file handling
# V3 Added support to analyze Business Service Execute timings 



echo "Please enter file name and place it in same folder"
read file_name
n_cnt=`find . -name "$file_name*" | wc -l`
echo "Reading files count -- $n_cnt"

if [ $n_cnt -eq 0 ]
then
	echo "No File Found Exiting Process"
	exit 0
fi

n=0

if [ $n_cnt -eq 1 ]
then 
	n=2
	k=5
else 
	n=3
	k=6
fi



grep 'WfPerf.*Proc.*|1|' $file_name* > Wfperf.tmp
grep 'SQL Statement' $file_name* > SQLPerf.tmp
grep 'WebSvcPerfInbound' $file_name* > WebSvcPerf.tmp
grep 'invoke method.*Execute Time:' $file_name* > BusServPerf.tmp

sort -nrk3 -t'|' Wfperf.tmp > Wfperf.log
sort -nrk$n -t':' SQLPerf.tmp > SQLPerf.log
sort -nrk2 -t'|' WebSvcPerf.tmp > WebSvcPerf.log
sort -nrk$k -t':' BusServPerf.tmp > BusServPerf.log
rm *tmp