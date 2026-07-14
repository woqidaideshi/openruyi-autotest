#!/bin/bash

# Performance: fio - sequential readwrite: Measure OS inblockdatabandwidth

. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 fioSetup

 TmpDir=$(mktemp -d)

 rlRun "cd $TmpDir" 0 "Enter temporary directory"

 _fioDropCaches

 rlPhaseEnd



 rlPhaseStartTest "sequential read throughput (different block sizes)"

 local testfile="$TmpDir/seq_read.dat"

 # preCreate test file (512MB)

 dd if=/dev/zero of="$testfile" bs=1M count=512 2>/dev/null



 for bs in 64 128 256 512 1024; do

 _fioDropCaches

 local log="$TmpDir/seq_read_${bs}k.log"

 rlLogInfo "=== sequential read BS=${bs}K ==="

 fio --name=seq_read_${bs}k --filename="$testfile" --direct=1 \

 --rw=read --bs=${bs}k --size=256M --numjobs=1 --iodepth=8 \

 --ioengine=libaio --runtime=30 --group_reporting 2>&1 | tee "$log"



 # extractbandwidth

 local bw

 bw=$(grep "READ:" "$log" | grep -oP 'bw=\K[\d.]+[KMG]iB/s' | head -1)

 if [ -n "$bw" ]; then

 echo " BS=${bs}K: BW=${bw}"

 rlPass "sequential read BS=${bs}K: ${bw}"

 fi

 done

 rm -f "$testfile"

 rlPhaseEnd



 rlPhaseStartTest "sequential write throughput (different block sizes)"

 _fioDropCaches

 for bs in 64 128 256 512 1024; do

 _fioDropCaches

 local log="$TmpDir/seq_write_${bs}k.log"

 rlLogInfo "=== sequential write BS=${bs}K ==="

 fio --name=seq_write_${bs}k --filename="$TmpDir/seq_write_${bs}k.dat" --direct=1 \

 --rw=write --bs=${bs}k --size=256M --numjobs=1 --iodepth=8 \

 --ioengine=libaio --runtime=30 --group_reporting 2>&1 | tee "$log"



 local bw

 bw=$(grep "WRITE:" "$log" | grep -oP 'bw=\K[\d.]+[KMG]iB/s' | head -1)

 if [ -n "$bw" ]; then

 echo " BS=${bs}K: BW=${bw}"

 rlPass "sequential write BS=${bs}K: ${bw}"

 fi

 rm -f "$TmpDir/seq_write_${bs}k.dat"

 done

 rlPhaseEnd



 rlPhaseStartCleanup "Cleanup"

 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""

 rlPhaseEnd

 rlJournalPrintText

rlJournalEnd

