batch=$1
idseq_part=/home/chenxufan/test/CRP/05.idseq_part
ls ${batch}/fq/*.fastq.gz > ${batch}/fq/fq.list
split -l 10 ${batch}/fq/fq.list -d -a 3 ${batch}/fq/`basename ${batch}`_

for i in `ls ${batch}/fq/part_*`; do 
    # echo ${i}
    mkdir -p ${idseq_part}/`basename ${batch}`/`basename ${i}`/fq

    for j in `cat ${i}`; do 
        # echo ${j}
        cp ${j} ${idseq_part}/`basename ${batch}`/`basename ${i}`/fq
        wait
    done
    # 生成ss.info文件
    python3 /home/chenxufan/test/CRP/idseq_script/ss_info.py ${idseq_part}/`basename ${batch}`/`basename ${i}`
    wait
done

