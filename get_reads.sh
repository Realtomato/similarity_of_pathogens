batch=$1
mkdir ${batch}/fq
cd ${batch}/fq

touch run.sh
for i in `ls ${batch}/genome`; do 
echo "python3 /home/chenxufan/test/CRP/idseq_script/get_reads.py ${batch}/genome/${i} ${batch}/fq/${i}.reads" >>run.sh
done
echo -n -e "`basename ${batch}`\t转换reads开始\t"; date "+%Y-%m-%d %H:%M:%S"
perl /home/chenxufan/bin/multi-process.pl -cpu 15 run.sh 2> run.sh.err 1> run.sh.log
wait
echo -n -e "`basename ${batch}`\t转换reads结束\t"; date "+%Y-%m-%d %H:%M:%S" 

# 抽样
touch run_sample.sh
for i in `ls ${batch}/fq/*.reads`; do 
    echo "seqtk sample ${batch}/fq/`basename ${i}` 100000 > ${batch}/fq/`basename ${i}`.fa" >> run_sample.sh
done
echo -n -e "`basename ${batch}`\t抽样开始\t"; date "+%Y-%m-%d %H:%M:%S"
perl /home/chenxufan/bin/multi-process.pl -cpu 15 run_sample.sh 2> run_sample.sh.err 1> run_sample.sh.log
wait
echo -n -e "`basename ${batch}`\t抽样结束\t"; date "+%Y-%m-%d %H:%M:%S"

touch run_seqtk.sh
for i in `ls ${batch}/fq/*.fa`; do
    echo "seqtk seq ${batch}/fq/`basename ${i}` -F \"E\" > ${batch}/fq/`basename ${i}`.fastq" >> run_seqtk.sh
done
echo -n -e "`basename ${batch}`\tfa2fq开始\t"; date "+%Y-%m-%d %H:%M:%S" 
perl /home/chenxufan/bin/multi-process.pl -cpu 15 run_seqtk.sh 2> run_seqtk.sh.err 1> run_seqtk.sh.log
wait
echo -n -e "`basename ${batch}`\tfa2fq结束\t"; date "+%Y-%m-%d %H:%M:%S" 
# 删除 .reads文件
rm ${batch}/fq/*.reads
rm ${batch}/fq/*.fa

for i in `ls ${batch}/fq/*.fastq`; do 
echo "gzip ${i}" >> gzip_fastq.sh
done
echo -n -e "`basename ${batch}`\t压缩文件开始\t"; date "+%Y-%m-%d %H:%M:%S" 
perl /home/chenxufan/bin/multi-process.pl -cpu 15 gzip_fastq.sh 2> gzip_fastq.sh.err 1> gzip_fastq.sh.log
wait
echo -n -e "`basename ${batch}`\t压缩文件结束\t"; date "+%Y-%m-%d %H-%M:%S"
echo -n -e "`basename ${batch}`\t04.idseq 结束\t"; date "+%Y-%m-%d %H-%M:%S"
echo '-------------------------------------------------'