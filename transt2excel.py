import os
import sys
import openpyxl

# crp = open(sys.argv[1])
# outf = open(sys.argv[2], 'w')
# record = {}
# for line in crp:
#     line = line.strip()
#     if line.startswith('#TargetSpecies'):
#         # outf.write(line)
#         continue
#     if not line: continue
#     lines = line.split('\t')
    
#     if lines[0]==lines[6]: #以拉丁名判断是否为同一物种
#         tar_spe, spe, tar_mrn, tar_smrn = lines[0], lines[6], lines[17], lines[18]
#         if tar_spe not in record:
#             record[tar_spe] = [tar_mrn, tar_smrn]
#             outf.write(tar_spe+'\t'+tar_mrn+'\t'+tar_smrn+'\n')
#         else:
#             print(tar_spe+' is already exist!!!')

# for line in crp:
#     line = line.strip()
#     if line.startswith('#TargetSpecies'):
#         outf.write(line)
#         continue
#     if not line: continue
#     lines = line.split('\t')
#     tar_spe, tar_chi, tar_gen, tar_gen_chi, tar_reads, Type, spe, spe_chi, genus, genus_chi, MRN, SMRN, cov = lines[0], lines[1], lines[2], lines[3], lines[4], lines[5], lines[6], lines[7], lines[8], lines[9], lines[17], lines[18], lines[21]

#     MRN_rate, SMRN_rate = MRN/record[0], SMRN/record[1] if tar_spe in record else 0, 0

#     outf.write(tar_spe+'\t' + tar_chi+'\t'+ tar_gen+'\t'+ tar_gen_chi+'\t'+ tar_reads+'\t'+ Type+'\t'+ spe+'\t'+ spe_chi+'\t'+ genus+'\t'+ genus_chi+'\t'+ MRN+'\t'+ SMRN+'\t'+MRN_rate+'\t'+ SMRN_rate+'\n')
#     # print(tar_spe, tar_chi, tar_gen, tar_gen_chi, tar_reads, Type, spe, spe_chi, genus, genus_chi, MRN, SMRN, cov)

crp = open(sys.argv[1])
outf = sys.argv[2]
record = open('/home/chenxufan/test/CRP/idseq_script/record.txt')
record_dict = {}
wb = openpyxl.Workbook()
ws = wb.active

for line in record:
    line = line.strip()
    if not line: continue
    lines = line.split('\t')
    spe, mrn, smrn = lines[0], lines[1], lines[2]
    if spe not in record_dict:
        record_dict[spe] = [mrn, smrn]
    else:
        print(spe + ' is already in records!!!')
    

for line in crp:
    line = line.strip()
    if line.startswith('#TargetSpecies'): 
        ws.append(['#TargetSpecies','TargetChinese', 'TargetGenus', 'TargetGenusChines', 'TargetReads', 'Type', 'Species', 'Chinese', 'Genus', 'GenusChinese', 'MRN', 'SMRN', 'MRN_rate', 'SMRN_rate'])
        # outf.write('#TargetSpecies\tTargetChinese\tTargetGenus\tTargetGenusChines\tTargetReads\tType\tSpecies\tChinese\tGenus\tGenusChinese\tMRN\tSMRN\tMRN_rate\tSMRN_rate\n')
        continue
    if not line: continue
    lines = line.split('\t')
    tar_spe, tar_chi, tar_gen, tar_gen_chi, tar_reads, Type, spe, spe_chi, genus, genus_chi, MRN, SMRN, cov = lines[0], lines[1], lines[2], lines[3], lines[4], lines[5], lines[6], lines[7], lines[8], lines[9], lines[17], lines[18], lines[21]
    if tar_spe in record_dict:
        MRN_rate = int(MRN)/int(record_dict[tar_spe][0]) if int(record_dict[tar_spe][0]) != 0 else 0
        SMRN_rate = int(SMRN)/int(record_dict[tar_spe][1]) if int(record_dict[tar_spe][1]) != 0 else 0
    else:
        MRN_rate, SMRN_rate = 0, 0

    ws.append([tar_spe, tar_chi, tar_gen, tar_gen_chi, tar_reads, Type, spe, spe_chi, genus, genus_chi, MRN, SMRN, MRN_rate, SMRN_rate])
    # outf.write(tar_spe+'\t' + tar_chi+'\t'+ tar_gen+'\t'+ tar_gen_chi+'\t'+ tar_reads+'\t'+ Type+'\t'+ spe+'\t'+ spe_chi+'\t'+ genus+'\t'+ genus_chi+'\t'+ MRN+'\t'+ SMRN+'\t'+str(MRN_rate)+'\t'+ str(SMRN_rate)+'\n')
    # print(tar_spe, tar_chi, tar_gen, tar_gen_chi, tar_reads, Type, spe, spe_chi, genus, genus_chi, MRN, SMRN, cov)
# outf.close()
wb.save(outf)