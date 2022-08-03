#!/bin/bash
if [ $# != 2 ] ; then
	echo "USAGE:sh $0 <ss.info> <outdir>"
	exit 1;
fi

SSINFO=$(readlink -f "$1")
OUTDIR=$2
BIN=/home/chenwenjing/pipeline/IDseq_v2.0/bin
#BIN=$(dirname $(readlink -f "$0"))

if [ ! -d "$OUTDIR" ]; then
	mkdir -p $OUTDIR
fi

OUTDIR=$(readlink -f "$OUTDIR")
BATCH=`basename $OUTDIR`
VERSION=`awk '{print $2}' $BIN/Version`

echo ""
echo "============================================================="
echo "       *********Running IDseq pipeline***********"
echo ""
echo "Version: $VERSION"
echo "Vision Medicals all rights reserved"
echo ""

## run IDseq
time1=$(date +%Y-%m-%d\ %H:%M:%S)
echo "$time1  Start running IDseq..."
python3 $BIN/main_pipeline.py.new $BIN/config.json $SSINFO $OUTDIR
sh $OUTDIR/00.shell/work.sh > $OUTDIR/00.shell/work.sh.log 2> $OUTDIR/00.shell/work.sh.err
time2=$(date +%Y-%m-%d\ %H:%M:%S)
echo "$time2  IDseq done. Use time(s): $(($(date --date="$time2" +%s)-$(date --date="$time1" +%s)))"
echo ""

### run qiangyang
#time3=$(date +%Y-%m-%d\ %H:%M:%S)
#echo "$time3  Start running qiangyang..."
#python3 $BIN/Get_sample_info_from_system.py /home/id_seq/WORK/IDseqV2/IDSeq_sample_info.xls
#perl $BIN/genus_species_distribution_in_one_run.pl $OUTDIR $OUTDIR/05.report/${BATCH}_result/qiangyang > $OUTDIR/06.log/qiangyang.log 2>&1
#time4=$(date +%Y-%m-%d\ %H:%M:%S)
#echo "$time4  qiangyang done. Use time(s): $(($(date --date="$time4" +%s)-$(date --date="$time3" +%s)))"
#echo ""
#
#timeM1=$(date +%Y-%m-%d\ %H:%M:%S)
#echo "$timeM1  Start running auto report for MARS2.0..."
### run auto report for MARS2.0
#perl /home/liuzu/scripts/1-MARS2.0-auto_report/auto_report_IDsqeV2_MARSV2/auto_report_add_duli.pl $OUTDIR $OUTDIR/05.report/auto_report2 > $OUTDIR/06.log/auto_report2.log 2> $OUTDIR/06.log/auto_report2.err
#perl /home/liuzu/scripts/1-MARS2.0-auto_report/gender_check/update_gender_check_result.pl $OUTDIR 2> $OUTDIR/06.log/update_gender_check_result2.err
#timeM2=$(date +%Y-%m-%d\ %H:%M:%S)
#echo "$time4  auto report for MARS2.0 done. Use time(s): $(($(date --date="$timeM2" +%s)-$(date --date="$timeM1" +%s)))"
#echo ""
#sh /home/chenwenjing/pipeline/IDseqEye/run_IDseqEye.sh guangzhou $OUTDIR/05.report/all.anno.xls $OUTDIR/IDseqEye > $OUTDIR/06.log/IDseqEye.log 2>&1
#
### run auto report
#time5=$(date +%Y-%m-%d\ %H:%M:%S)
#echo "$time5  Start running auto report..."
#perl $BIN/add_qc_to_mysql.pl $OUTDIR > $OUTDIR/06.log/add_qc_to_mysql.log 2> $OUTDIR/06.log/add_qc_to_mysql.err
#perl $BIN/auto_report/auto_report.pl $OUTDIR $OUTDIR/05.report/auto_report >  $OUTDIR/06.log/auto_report.log 2> $OUTDIR/06.log/auto_report.err
#perl $BIN/update_gender_check_result.pl $OUTDIR 2> $OUTDIR/06.log/update_gender_check_result.err
#time6=$(date +%Y-%m-%d\ %H:%M:%S)
#echo "$time6  auto report done. Use time(s): $(($(date --date="$time6" +%s)-$(date --date="$time5" +%s)))"
#echo ""
#
### run UMSI (lz)###########################
#time_U1=$(date +%Y-%m-%d\ %H:%M:%S)
#echo "$time_U1  Start running UMSI..."
#perl $BIN/neican/neican_QC_for_IDseq.pl $OUTDIR >$OUTDIR/06.log/UMSI.log 2> $OUTDIR/06.log/UMSI.err
#rm -r $OUTDIR/UMSI/*sam
#time_U2=$(date +%Y-%m-%d\ %H:%M:%S)
#echo "$time_U2  UMSI done. Use time(s): $(($(date --date="$time_U2" +%s)-$(date --date="$time_U1" +%s)))"
#echo ""
####################################################
#
#
#echo "Run core pipeline total use time(s): $(($(date --date="$time_U2" +%s)-$(date --date="$time1" +%s)))"
#echo ""
#
### run auto blast 
#time_blast1=$(date +%Y-%m-%d\ %H:%M:%S)
#echo "$time_blast1  Start running blast..."
#sh $BIN/auto_blast/bin/auto_blast_IDseq.sh $OUTDIR $OUTDIR/05.report/auto_blast >$OUTDIR/06.log/blast.log 2> $OUTDIR/06.log/blast.err
#time_blast2=$(date +%Y-%m-%d\ %H:%M:%S)
#echo "$time_blast2  blast done. Use time(s): $(($(date --date="$time_blast2" +%s)-$(date --date="$time_blast1" +%s)))"
#echo ""
#
### tar report data and send email
#time_A1=$(date +%Y-%m-%d\ %H:%M:%S)
#echo "$time_A1  Start Archiving data and send mail..."
#find $OUTDIR -name "*err" |xargs -I {} ls -l {}|awk '$5>0{print $9}'|xargs -I {} cp {} $OUTDIR/05.report/${BATCH}_result/Warning_files
#cp -r $OUTDIR/05.report/${BATCH}_result $OUTDIR/05.report/${BATCH}_result_tmp
#rm -rf $OUTDIR/05.report/${BATCH}_result_tmp/depth_plot
#cd $OUTDIR/05.report
#tar -cf ${BATCH}_result.tar ${BATCH}_result_tmp > $OUTDIR/06.log/tar.log 2>&1
#xz -9 $OUTDIR/05.report/${BATCH}_result.tar
#rm -rf $OUTDIR/05.report/${BATCH}_result_tmp
#python3 $BIN/send_mail.py -subject $BATCH -attach $OUTDIR/05.report/${BATCH}_result.tar.xz > $OUTDIR/06.log/send_mail.log 2> $OUTDIR/06.log/send_mail.err
#cp -r $OUTDIR/05.report/auto_report $OUTDIR/05.report/${BATCH}_result
#time_A2=$(date +%Y-%m-%d\ %H:%M:%S)
#echo "$time_A2  Send mail done. Use time(s): $(($(date --date="$time_A2" +%s)-$(date --date="$time_A1" +%s)))"
#echo ""
#
#sh $BIN/err_check.sh $OUTDIR > $OUTDIR/06.log/err_check.log 2> $OUTDIR/06.log/err_check.err
#
### backup data
#time_B1=$(date +%Y-%m-%d\ %H:%M:%S)
#echo "$time_B1  Start backup data..."
#chmod -R 755 $OUTDIR
#scp -r $OUTDIR/05.report/${BATCH}_result jieduadmin@192.168.1.109:/hdd1/IDseqReportShare/IDseqV2_Result/ > $OUTDIR/06.log/result_backup.log 2>&1
#rsync -au -e "ssh -p 518" $OUTDIR weiyuan@192.168.1.13:/hdd3/Data_back/IDseqV2 > $OUTDIR/06.log/data_backup.log 2>&1
#time_B2=$(date +%Y-%m-%d\ %H:%M:%S)
#echo "$time_B2  Backup data done. Use time(s): $(($(date --date="$time_B2" +%s)-$(date --date="$time_B1" +%s)))"
#echo ""


time7=$(date +%Y-%m-%d\ %H:%M:%S)
echo "$time7  All done"
echo "Run IDseq pipeline finished.  Total use time(s): $(($(date --date="$time7" +%s)-$(date --date="$time1" +%s)))"
echo "============================================================="
echo ""
