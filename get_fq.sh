#for i in `ls /home/chenxufan/test/similarity/reads`; do 
#seqtk seq /home/chenxufan/test/similarity/reads/${i} -F "E" > /home/chenxufan/test/similarity/fq/${i}.fq
#done
for i in `ls /home/chenxufan/test/similarity/fq`; do
python /home/chenxufan/test/similarity/script/cp2fq.py /home/chenxufan/test/similarity/fq/${i}
done
