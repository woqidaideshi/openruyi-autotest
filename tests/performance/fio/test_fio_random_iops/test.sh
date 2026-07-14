#!/bin/bash

# Performance: fio - random I/O IOPS: Measure OS inrandommode IOPS 

. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    fioSetup

    TmpDir=$(mktemp -d)

    rlRun "cd $TmpDir" 0 "Enter temporary directory"

    rlPhaseEnd



    rlPhaseStartTest "random read IOPS (different block sizes)"

    local testfile="$TmpDir/randread.dat"

    dd if=/dev/zero of="$testfile" bs=1M count=256 2>/dev/null



    for bs in 4 16 32 64; do

    _fioDropCaches

    local log="$TmpDir/randread_${bs}k.log"

    rlLogInfo "=== random read BS=${bs}K ==="

    fio --name=randread_${bs}k --filename="$testfile" --direct=1 \

    --rw=randread --bs=${bs}k --size=128M --numjobs=4 --iodepth=16 \

    --ioengine=libaio --runtime=20 --thread --group_reporting 2>&1 | tee "$log"



    local iops bw

    iops=$(grep "read:" "$log" | grep -oP 'IOPS=\K[\d.]+k?' | head -1)

    bw=$(grep "READ:" "$log" | grep -oP 'bw=\K[\d.]+[KMG]iB/s' | head -1)

    echo " BS=${bs}K: IOPS=${iops}, BW=${bw}"

    if [ -n "$iops" ]; then rlPass "random read BS=${bs}K: IOPS=${iops}"; fi

    done

    rm -f "$testfile"

    rlPhaseEnd



    rlPhaseStartTest "randomwrite IOPS (different block sizes)"

    for bs in 4 16 32 64; do

    _fioDropCaches

    local log="$TmpDir/randwrite_${bs}k.log"

    rlLogInfo "=== randomwrite BS=${bs}K ==="

    fio --name=randwrite_${bs}k --filename="$TmpDir/randwrite_${bs}k.dat" --direct=1 \

    --rw=randwrite --bs=${bs}k --size=128M --numjobs=4 --iodepth=16 \

    --ioengine=libaio --runtime=20 --thread --group_reporting 2>&1 | tee "$log"



    local iops bw

    iops=$(grep "write:" "$log" | grep -oP 'IOPS=\K[\d.]+k?' | head -1)

    bw=$(grep "WRITE:" "$log" | grep -oP 'bw=\K[\d.]+[KMG]iB/s' | head -1)

    echo " BS=${bs}K: IOPS=${iops}, BW=${bw}"

    if [ -n "$iops" ]; then rlPass "randomwrite BS=${bs}K: IOPS=${iops}"; fi

    rm -f "$TmpDir/randwrite_${bs}k.dat"

    done

    rlPhaseEnd



    rlPhaseStartCleanup "Cleanup"

    rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""

    rlPhaseEnd

    rlJournalPrintText

rlJournalEnd

