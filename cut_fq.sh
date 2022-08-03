batch=$1
for i in `ls ${batch}/fq/*.fastq.gz`; do 
echo ${i}
done
