import os
import sys

inf = sys.argv[1]    # 输入基因组文件
outf = sys.argv[2]
step = int(sys.argv[3])
inf = open(inf)
outf = open(outf, 'w')	# 输入.reads文件

seq_names = []
seqs = []
seq = ''

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
	print('Error')

# print(len(seqs[1]))
count = 0
for i in range(len(seq_names)):
	seq_name = seq_names[i]
	seq = seqs[i]
	

	for j in range(0, len(seq), step):
		outf.write('{0}_{1}\n'.format(seq_name, count))
		if len(seq[j:j+40])<40:
			outf.write(seq[(j-10):] + '\n')
			break
		outf.write(seq[j:j+40] + '\n')
		count += 1
outf.close()