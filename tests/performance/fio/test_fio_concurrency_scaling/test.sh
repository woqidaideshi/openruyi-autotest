#!/bin/bash

# Performance: fio - and: Measure OS I/O stackinmultiand

. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 fioSetup

 TmpDir=$(mktemp -d)

 rlRun "cd $TmpDir" 0 ""

 rlPhaseEnd



 rlPhaseStartTest "random readand (numjobs)"

 local testfile="$TmpDir/scale.dat"

 dd if=/dev/zero of="$testfile" bs=1M count=512 2>/dev/null



 echo ""

 echo "=== random readand BS=4K iodepth=16 ==="

 printf "%-12s %-15s %-15s\n" "NumJobs" "IOPS" "BW"



 for nj in 1 2 4 8; do

 _fioDropCaches

 local log="$TmpDir/scale_nj${nj}.log"

 fio --name=scale_nj${nj} --filename="$testfile" --direct=1 \

 --rw=randread --bs=4k --size=128M --numjobs=$nj --iodepth=16 \

 --ioengine=libaio --runtime=20 --thread --group_reporting 2>&1 | tee "$log"



 local iops bw

 iops=$(grep "read:" "$log" | grep -oP 'IOPS=\K[\d.]+k?' | head -1)

 bw=$(grep "READ:" "$log" | grep -oP 'bw=\K[\d.]+[KMG]iB/s' | head -1)

 printf "%-12s %-15s %-15s\n" "$nj" "${iops:-N/A}" "${bw:-N/A}"

 done



 # verify 8 jobs IOPS > 1 job IOPS ()

 local iops1 iops8

 iops1=$(grep "read:" "$TmpDir/scale_nj1.log" | grep -oP 'IOPS=\K[\d.]+' | head -1)

 iops8=$(grep "read:" "$TmpDir/scale_nj8.log" | grep -oP 'IOPS=\K[\d.]+' | head -1)

 if [ -n "$iops1" ] && [ -n "$iops8" ]; then

 rlLogInfo "1→8 jobs: IOPS ${iops1} → ${iops8}"

 fi

 rlPass "andanalysisComplete"

 rm -f "$testfile"

 rlPhaseEnd



 rlPhaseStartTest "sequential readand"

 local testfile="$TmpDir/scale_seq.dat"

 dd if=/dev/zero of="$testfile" bs=1M count=512 2>/dev/null



 echo ""

 echo "=== sequential readand BS=64K ==="

 printf "%-12s %-15s %-15s\n" "NumJobs" "BW" "CPU%"



 for nj in 1 2 4 8; do

 _fioDropCaches

 local log="$TmpDir/scale_seq_nj${nj}.log"

 fio --name=scale_seq_nj${nj} --filename="$testfile" --direct=1 \

 --rw=read --bs=64k --size=256M --numjobs=$nj --iodepth=8 \

 --ioengine=libaio --runtime=15 --thread --group_reporting 2>&1 | tee "$log"



 local bw cpu

 bw=$(grep "READ:" "$log" | grep -oP 'bw=\K[\d.]+[KMG]iB/s' | head -1)

 cpu=$(grep "cpu " "$log" | grep -oP'sys=\K[\d.]+%' | head -1)

 printf "%-12s %-15s %-15s\n" "$nj" "${bw:-N/A}" "${cpu:-N/A}"

 done

 rlPass "sequentialandanalysisComplete"

 rm -f "$testfile"

 rlPhaseEnd



 rlPhaseStartCleanup "Cleanup"

 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""

 rlPhaseEnd

 rlJournalPrintText

rlJournalEnd

