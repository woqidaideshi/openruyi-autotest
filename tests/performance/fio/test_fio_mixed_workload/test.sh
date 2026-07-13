#!/bin/bash
# Performance: fio - readwriteload: datalibrary/shouldwithrandom IO
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 fioSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 ""
 rlPhaseEnd

 rlPhaseStartTest "datalibraryload (70R/30W, BS=8K)"
 local testfile="$TmpDir/db_workload.dat"
 local log="$TmpDir/db_randrw.log"

 rlLogInfo "=== datalibraryload: 70%read 30%write, BS=8K, 8jobs, iodepth=16 ==="
 _fioDropCaches
 fio --name=db_mixed --filename="$testfile" --direct=1 \
 --rw=randrw --rwmixread=70 --bs=8k --size=256M \
 --numjobs=8 --iodepth=16 --ioengine=libaio \
 --runtime=60 --thread --group_reporting 2>&1 | tee "$log"

 echo ""
 echo "=== datalibraryloadresult ==="
 cat "$log"
 _fioParseResult "$log"

 # checkreadwriteall hashasdata
 grep -q "read:" "$log" && rlPass "readdatahas"
 grep -q "write:" "$log" && rlPass "writedatahas"
 rm -f "$testfile"
 rlPhaseEnd

 rlPhaseStartTest "Web serverload (80R/20W, BS=4K)"
 local testfile="$TmpDir/web_workload.dat"
 local log="$TmpDir/web_randrw.log"

 rlLogInfo "=== Web serverload: 80%read 20%write, BS=4K, 4jobs ==="
 _fioDropCaches
 fio --name=web_mixed --filename="$testfile" --direct=1 \
 --rw=randrw --rwmixread=80 --bs=4k --size=128M \
 --numjobs=4 --iodepth=32 --ioengine=libaio \
 --runtime=30 --thread --group_reporting 2>&1 | tee "$log"

 echo ""
 echo "=== Web loadresult ==="
 cat "$log"
 _fioParseResult "$log"
 rm -f "$testfile"
 rlPass "loadtestComplete"
 rlPhaseEnd

 rlPhaseStartTest "read/write ratiocomparison (50/50, 70/30, 90/10)"
 echo ""
 echo "=== read/write ratio vs total ==="
 printf "%-10s %-15s %-15s %-15s\n" "R/W" "Read IOPS" "Write IOPS" "Total BW"

 for ratio in 50 70 90; do
 local testfile="$TmpDir/rw${ratio}.dat"
 local log="$TmpDir/rw${ratio}.log"
 _fioDropCaches
 fio --name=rw${ratio} --filename="$testfile" --direct=1 \
 --rw=randrw --rwmixread=$ratio --bs=8k --size=64M \
 --numjobs=4 --iodepth=16 --ioengine=libaio \
 --runtime=15 --thread --group_reporting 2>&1 | tee "$log"

 local riops wiop bw
 riops=$(grep "read:" "$log" | grep -oP 'IOPS=\K[\d.]+k?' | head -1)
 wiop=$(grep "write:" "$log" | grep -oP 'IOPS=\K[\d.]+k?' | head -1)
 bw=$(grep "READ:" "$log" | grep -oP 'bw=\K[\d.]+[KMG]iB/s' | head -1)
 printf "%-10s %-15s %-15s %-15s\n" "${ratio}/$((100-ratio))" "${riops:-N/A}" "${wiop:-N/A}" "${bw:-N/A}"
 rm -f "$testfile"
 done
 rlPass "read/write ratiocomparisonComplete"
 rlPhaseEnd

 rlPhaseStartCleanup "Cleanup"
 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
 rlPhaseEnd
 rlJournalPrintText
rlJournalEnd
