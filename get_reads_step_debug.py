import os
import sys
import re
import numpy as np 

# if len(sys.argv) != 3:
# 	print('Usage: Python3 %s <genome> <output>' %sys.argv[0])
# 	exit()

# inf_path = sys.argv[1]    #输入基因组文件
# outf_path = sys.argv[2]
# step = int(sys.argv[3])

inf_path = '/home/chenxufan/test/similarity/test2/Klebsiella_pneumoniae'    #输入基因组文件
outf_path = '/home/chenxufan/test/similarity/test2/Klebsiella_pneumoniae.reads'
inf = open(inf_path)
outf = open(outf_path, 'w')	#输入.reads文件

seq_names = []
seqs = []
seq = ''

def get_reads_by_step(seq_names, seqs, step, outf):
	count = 0
	for i in range(len(seq_names)):
		seq_name = seq_names[i]
		seq = seqs[i]
		
		for j in range(0, len(seq)-39, step):
			outf.write('{0}_{1}\n'.format(seq_name, count))
			if len(seq[j:j+40])<40:
				outf.write(seq[(j-10):(j+40)] + '\n')
				break
			outf.write(seq[j:j+40] + '\n')
			count += 1
	outf.close()

def get_reads_by_random(seq_names, seqs, ScoreOfScaffolds, outf):
	count = 0
	for i in range(len(seq_names)):
		seq_name = seq_names[i]
		seq = seqs[i]
		random_idx = np.random.choice(len(seq)-39, ScoreOfScaffolds[i], replace=False)	#生成随机数
		# print(random_idx[0:11])
		for j in random_idx:
			outf.write('{0}_{1}\n'.format(seq_name, count))
			outf.write(seq[j:j+40] + '\n')
			count += 1
	outf.close()

for line in inf:
	line = line.strip()
	if (line == '') | (line == '\n'):
		continue

	if line.startswith(">"):
		seq_name = line
		seq_name = seq_name.replace(' ', '_')
		seq_names.append(seq_name)
		seqs.append(seq)
		seq = ''
		continue
	seq = seq + line
seqs.append(seq)
seqs = seqs[1:]	# 去掉seqs的第一个''

if len(seqs) != len(seq_names):
	print(inf_path + 'has different number of seq_names and sequence!')
	exit()

NumOfReadsNeed = 100*1000	#需要生成的reads数，目前控制在10万条
LenOfScaffolds = [len(i) for i in seqs]	#每个scaffolds的base数
# print(LenOfScaffolds[0:11])
TotalBases = sum(LenOfScaffolds)	#计算基因组总base数

#基因组可以生成的reads数<100*1000, 设置step为1
if TotalBases - 39 * len(LenOfScaffolds) <= 100*1000:
	step = 1
	get_reads_by_step(seq_names, seqs, step, outf)

#100*1000< 基因组可以生成的reads数 <40*100*1000, 生成随机数
if (100*1000+40-1 < (TotalBases - 39 * len(LenOfScaffolds))) & ((TotalBases - 39 * len(LenOfScaffolds)) < 100*1000*40): 
	ScoreOfScaffolds = [int(i/TotalBases*100*1000)+1 for i in LenOfScaffolds]	#按每个scaffold碱基数加权
	print(ScoreOfScaffolds[0:11])
	get_reads_by_random(seq_names, seqs, ScoreOfScaffolds, outf)

#基因组可以生成的reads数>40*100*1000, 根据基因组大小设置step
if TotalBases - 39 * len(LenOfScaffolds) >= 40*100*1000:
	step = int(TotalBases/(100*1000))
	get_reads_by_step(seq_names, seqs, step, outf)

#随机抽样
# seqtk sample -2 -s 11 in_fa 100000 | seqtk seq -F "E" > out_fa 
