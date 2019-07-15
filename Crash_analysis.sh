#Owner : Shiv Prateek Sharma
#Created: 04-Aug-2018
#Created to simplify the crash fdr file analysis

crash_create()
    {
    grep "CRASHING THREAD" $1* | head -n1 > crash_chk.tmp
    crash_thrd=`cut -d',' -f3 crash_chk.tmp`
    grep $crash_thrd $1* > crash_fl.tmp
    echo "FdrID,UTC,ThreadID,AreaSymbol,AreaDesc,SubAreaSymbol,SubAreaDesc,UserInt1,UserInt2,UserStr1,UserStr2">File_Crash_$crash_thrd.csv
    sort -nrk1 -t',' crash_fl.tmp >> File_Crash_$crash_thrd.csv
    }

echo "Please enter file name and place it in same folder"
read file_name

n_cnt=`find . -name "$file_name*" | wc -l`
echo "Reading files count -- $n_cnt"

ls $file_name* > file_lst.tmp

for i in $( cat file_lst.tmp)
do
echo $i
crash_create $i
done
 
 rm *.tmp

