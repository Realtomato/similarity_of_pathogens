import os
from random import sample
import sys
from subprocess import getoutput as cmd

CRP_SIM = open(sys.argv[1])
outf = open(sys.argv[2], 'w')

ss_info = '/home/chenxufan/test/CRP/species.info'
ss_info = open(ss_info)

reads_info = '/home/chenxufan/test/CRP/idseq_script/spe-reads.info'
reads_info = open(reads_info)
ss_info_dict = {}
reads_dict = {}

for line in reads_info:
    line = line.strip()
    if line == '': continue
    lines = line.split('\t')
    if len(lines) < 2:
        print(line+'less than 2 column!!!')

    spe, reads = lines[0].split('.fastq.gz')[0], lines[1]

    if spe not in reads_dict:
        reads_dict[spe] = reads
    else:
        print(spe+' already in reads_dict!!!')


for line in ss_info:
    line = line.strip()
    if line.startswith('#'): continue
    lines = line.split('\t')
    species, Chinese, genus, genusChinese = lines[3], lines[4], lines[5], lines[6]

    if species not in ss_info_dict:
        ss_info_dict[species] = [Chinese, genus, genusChinese]
    else:
        print(species+'already in ss_info_dict!!!')

outf.write('#TargetSpecies\tTargetChinese\tTargetGenus\tTargetGenusChines\tTargetReads\tType\tSpecies\tChinese\tGenus\tGenusChinese\tRe_Abu\tRe_Abu_Genus\tIdentity\tSDMRN\tSDSMRN\tSDMRNG\tSDSMRNG\tMRN\tSMRN\tMRNG\tSMRNG\tCoverage\tCov_rate\tDepth\tPredictDepth\tDepth_rate\tabs_Abu\tabs_Abu_Genus\tGram\tConfidence\tReads_index\tDepth_index\tDispersion_index\tBAR\tcoreSAR\tcoreRate\n')
for line in CRP_SIM:
    line = line.strip()
    if line.startswith('#'): continue
    if line == '': continue

    lines = line.split('\t')
    sample, sample_info = lines[0], '\t'.join(lines[1:])

    if (sample in ss_info_dict) & (sample in reads_dict):
        ss_data = '\t'.join(ss_info_dict[sample])
        reads_data = reads_dict[sample]
        outf.write(sample+'\t'+ss_data+'\t'+reads_data+'\t'+sample_info+'\n')
    else:
        print(sample+' has uncompletily infomation!!!')
outf.close()
