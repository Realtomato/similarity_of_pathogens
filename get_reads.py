import os
import sys

inf = sys.argv[1]
outf = sys.argv[2]
inf = open(inf)
outf = open(outf, 'w')

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
seqs = seqs[1:]

if len(seqs) != len(seq_names):
	print('Error')
	exit()

count = 0
for i in range(len(seq_names)):
	seq_name = seq_names[i]
	seq = seqs[i]
	for j in range(0, len(seq)-39):
		outf.write('{0}_{1}\n'.format(seq_name, count))
		outf.write(seq[j:j+40] + '\n')
		count += 1
outf.close()