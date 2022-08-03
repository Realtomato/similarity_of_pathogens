for i in `ls /home/chenxufan/test/similarity/test/04.anno/`; do 
echo $i
awk '$1=="'"$i"'" {print }' /home/chenxufan/test/similarity/test/05.report/all.anno.xls > /home/chenxufan/test/similarity/test/05.report/${i}.anno.xls.bc
cat /home/chenxufan/test/similarity/test/05.report/header.txt /home/chenxufan/test/similarity/test/05.report/${i}.anno.xls.bc > /home/chenxufan/test/similarity/test/05.report/${i}.anno.xls
done
