import os
import sys
import subprocess
from os.path import join as path

# batch_dir = '/home/chenxufan/test/similarity/test2'
batch_dir = sys.argv[1]
fq_dir = path(batch_dir, 'fq')
ss_info = path(batch_dir, 'ss.info')
# print(ss_info)
# s = subprocess.getoutput('ls /home/chenxufan/test/similarity/test/fq')
fq = subprocess.getoutput('ls {0}/*.fastq.gz'.format(fq_dir))
fq = fq.split()
# print(fq)
outf = open(ss_info, 'w')
for i in fq:
	i = subprocess.getoutput('basename {0}'.format(i))
	# print(i)
	sample_name = i.split('.fastq.gz')[0]
	outf.write(sample_name + '\tDNA\t' + fq_dir + '/' + i + '\n')
outf.close()