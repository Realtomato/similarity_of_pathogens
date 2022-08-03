import os 
import sys
from subprocess import getoutput as cmd
from os.path import join as path

batch = sys.argv[1]
part1 = cmd('basename {0}'.format(batch)) # 04.idseq的basename
CRP_dir = '/home/chenxufan/test/CRP'
os.system('ls {0}/fq/*.fastq.gz > {0}/fq/fq.list'.format(batch)) # 生成fq.list

# 计算fq文件数量
num_of_fq = cmd('wc -l {0}/fq/fq.list'.format(batch)).split()[0]
num_of_fq = int(num_of_fq)

# 计算相应fq文件夹数量, 每20个fq文件放到1个fq文件夹
num_of_fold = num_of_fq//20+1 if num_of_fq%20!=0 else num_of_fq//20

# 创建divide的fq文件夹
for i in range(num_of_fold):
	cmd('mkdir -p {0}/05.idseq_part/{1}/{1}_00{2}/fq'.format(CRP_dir, part1, i))

f = open('{0}/fq/fq.list'.format(batch))
count = 1 
part2 = 0
for line in f:
	line = line.strip()
	if line == '': continue
	if (count%20 == 1) & (count//20!=0): # 每20个文件放到1个文件夹
		part2 += 1
	fold = '{0}/05.idseq_part/{1}/{1}_00{2}/fq'.format(CRP_dir, part1, part2)
	cmd('ln -s {0} {1}'.format(line, fold))
	count += 1




