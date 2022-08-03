# import subprocess
import sys
import os

inf = sys.argv[1]
# print(inf)
outf = inf.split('.reads.fa.fastq.gz')[0]+'.fastq.gz'
# print(outf)
os.system('mv {0} {1}'.format(inf, outf))