#生成ftp文件
# python3 /home/chenxufan/test/CRP/script/grep_ftp.py /home/chenxufan/test/CRP/01.spe_exist/spe_exit /home/chenxufan/bin/assembly_summary_genbank.txt > /home/chenxufan/test/CRP/02.grep_ftp/spe_ftp 2> /home/chenxufan/test/CRP/02.grep_ftp/grep_ftp.py.err 1> /home/chenxufan/test/CRP/02.grep_ftp/grep_ftp.py.log
# split -l 100 /home/chenxufan/test/CRP/02.grep_ftp/spe_ftp -d -a 3 /home/chenxufan/test/CRP/02.grep_ftp/spe_ftp_

for i in `ls /home/chenxufan/test/CRP/02.grep_ftp/spe_ftp_0*`; do 
    mkdir /home/chenxufan/test/CRP/03.download/`basename ${i}`
	python3 /home/chenxufan/test/CRP/script/download.py ${i} /home/chenxufan/test/CRP/03.download/`basename ${i}` > /home/chenxufan/test/CRP/03.download/`basename ${i}`.sh
done

for i in `ls /home/chenxufan/test/CRP/03.download/*0*.sh`; do 
	perl /home/chenxufan/bin/multi-process.pl -cpu 15 ${i} 2> ${i}.err 1> ${i}.log
    sleep 10s
done
# #复制基因组数据到04.idseq
# download_dir=/home/chenxufan/test/CRP/03.download
# for i in {000..022}; do 
# mkdir -p /home/chenxufan/test/CRP/04.idseq/part_${i}/genome
# cp ${download_dir}/spe_ftp_${i}/*.gz /home/chenxufan/test/CRP/04.idseq/part_${i}/genome
# done
# gunzip /home/chenxufan/test/CRP/04.idseq/p*/genome/*.gz
#######################################################以step为1打断基因组, 用seqtk sample抽取10万条reads


# batch=$1
# for part2 in `ls ${batch}`; do
# cd ${batch}/${part2}
# python3 /home/chenxufan/test/CRP/idseq_script/ss_info.py ${batch}/${part2} 2> ${batch}/${part2}/ss_info.py.err 1> ${batch}/${part2}/ss_info.py.log
# wait
# sh /home/chenxufan/work/id_seq/auto_run_IDseq.sh ${batch}/${part2}/ss.info ${batch}/${part2} > ${batch}/${part2}/auto_run.log 2>&1
# wait

# 删除idseq分析过程中产生的较大的文件
# rm ${batch}/${part2}/02*/*/*.fq ${batch}/${part2}/02*/*/*.fastq
# rm -r ${batch}/${part2}/03*/*
# rm ${batch}/${part2}/04*/*/*.sam 
# rm -r ${batch}/${part2}/05*/*
# wait 
# sleep 1m
# done
#sh /home/chenxufan/test/CRP/idseq_script/get_reads.sh ${batch} 2> ${batch}/get_reads.sh.err 1> ${batch}/get_reads.sh.log

# 重命名为fastq.gz
#for i in `ls ${batch}/fq/*.reads.fastq.gz`; do 
#python3 /home/chenxufan/test/CRP/idseq_script/cp2fq.py ${i}
#done

# ss.info

#python3 /home/chenxufan/test/CRP/idseq_script/ss_info.py ${batch} 2> ${batch}/ss_info.py.err 1> ${batch}/ss_info.py.log
