#生成ftp文件
# python3 /home/chenxufan/test/CRP/script/grep_ftp.py /home/chenxufan/test/CRP/01.spe_exist/spe_exit /home/chenxufan/bin/assembly_summary_genbank.txt > /home/chenxufan/test/CRP/02.grep_ftp/spe_ftp 2> /home/chenxufan/test/CRP/02.grep_ftp/grep_ftp.py.err 1> /home/chenxufan/test/CRP/02.grep_ftp/grep_ftp.py.log
# split -l 100 /home/chenxufan/test/CRP/02.grep_ftp/spe_ftp -d -a 3 /home/chenxufan/test/CRP/02.grep_ftp/spe_ftp_

# for i in `ls /home/chenxufan/test/CRP/02.grep_ftp/spe_ftp_0*`; do 
#     mkdir /home/chenxufan/test/CRP/03.download/`basename ${i}`
# 	python3 /home/chenxufan/test/CRP/script/download.py ${i} /home/chenxufan/test/CRP/03.download/`basename ${i}` > /home/chenxufan/test/CRP/03.download/`basename ${i}`.sh
# done
# #下载基因组文件
# for i in `ls /home/chenxufan/test/CRP/03.download/*0*.sh`; do 
# 	perl /home/chenxufan/bin/multi-process.pl -cpu 15 ${i} 2> ${i}.err 1> ${i}.log
#     sleep 10s
# done
#复制基因组数据到04.idseq, 并且解压缩
# download_dir=/home/chenxufan/test/CRP/03.download
# for i in {000..022}; do 
#     mkdir -p /home/chenxufan/test/CRP/04.idseq/part_${i}/genome
#     cp ${download_dir}/spe_ftp_${i}/*.gz /home/chenxufan/test/CRP/04.idseq/part_${i}/genome
# done
# gunzip /home/chenxufan/test/CRP/04.idseq/p*/genome/*.gz
# wait

# # 设置step为1打断基因组, 随机抽10万条reads, 转换为fastq格式, 压缩
# touch /home/chenxufan/test/CRP/04.idseq/get_reads.log
# touch /home/chenxufan/test/CRP/04.idseq/get_reads.err
# for i in /home/chenxufan/test/CRP/04.idseq/part*; do 
#     bash /home/chenxufan/test/CRP/idseq_script/get_reads.sh ${i} 2>>/home/chenxufan/test/CRP/04.idseq/get_reads.err 1>> /home/chenxufan/test/CRP/04.idseq/get_reads.log
# done
# # 修改fastq.gz文件名
# for i in `ls /home/chenxufan/test/CRP/04.idseq/part_0*/fq/*reads.fa.fastq.gz`; do
#     python3 /home/chenxufan/test/CRP/idseq_script/cp2fq.py ${i}
# done

#04.idseq每个part_*文件夹约100个fastq.gz文件, 按fastq.gz数量分为若干文件夹, 每个文件夹约30个fastq.gz
for i in /home/chenxufan/test/CRP/04.idseq/part_02*; do 
    ls ${i}/fq/*.fastq.gz > ${i}/fq/test.list
    split -l 30 ${i}/fq/test.list -d -a 3 ${i}/`basename ${i}`_
    for j in ${i}/part*; do 
        mkdir -p /home/chenxufan/test/CRP/05.idseq_part/`basename ${i}`/`basename ${j}`/fq
        for k in `cat ${j}`; do 
            ln -s ${k} /home/chenxufan/test/CRP/05.idseq_part/`basename ${i}`/`basename ${j}`/fq
        done
        python3 /home/chenxufan/test/CRP/idseq_script/ss_info.py /home/chenxufan/test/CRP/05.idseq_part/`basename ${i}`/`basename ${j}`
        cd /home/chenxufan/test/CRP/05.idseq_part/`basename ${i}`/`basename ${j}`
        sh /home/chenxufan/test/CRP/idseq_script/auto_run_IDseq.sh /home/chenxufan/test/CRP/05.idseq_part/`basename ${i}`/`basename ${j}`/ss.info /home/chenxufan/test/CRP/05.idseq_part/`basename ${i}`/`basename ${j}` > /home/chenxufan/test/CRP/05.idseq_part/`basename ${i}`/`basename ${j}`/auto_run.log 2>&1
        wait 
        rm /home/chenxufan/test/CRP/05.idseq_part/`basename ${i}`/`basename ${j}`/02.map_host/*/*.fastq /home/chenxufan/test/CRP/05.idseq_part/`basename ${i}`/`basename ${j}`/02.map_host/*/*.fq
        rm -r /home/chenxufan/test/CRP/05.idseq_part/`basename ${i}`/`basename ${j}`/03*
        rm /home/chenxufan/test/CRP/05.idseq_part/`basename ${i}`/`basename ${j}`/04.anno/*/*.sam
        rm -r /home/chenxufan/test/CRP/05.idseq_part/`basename ${i}`/`basename ${j}`/05*
        wait
    done
    # mkdir -p /home/chenxufan/test/CRP/05.idseq_part/`basename ${i}`/
    # ln -s ${i}/fq/*.fastq.gz /home/chenxufan/test/CRP/05.idseq_part/part_000/part_000_000/fq
done


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
