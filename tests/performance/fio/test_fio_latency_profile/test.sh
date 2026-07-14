#!/bin/bash

# Performance: fio - latencyanalysis: Measure OS indifferent I/O shouldlatency

. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    fioSetup

    TmpDir=$(mktemp -d)

    rlRun "cd $TmpDir" 0 ""

    local testfile="$TmpDir/latency.dat"

    dd if=/dev/zero of="$testfile" bs=1M count=256 2>/dev/null

    rlPhaseEnd



    rlPhaseStartTest "latency vs queue depth (random read 4K)"

    echo ""

    echo "=== latency vs queue depth (BS=4K, randread) ==="

    printf "%-10s %-12s %-12s %-12s\n" "QDepth" "Avg(us)" "P50(us)" "P99(us)"



    for qd in 1 4 16 32; do

    _fioDropCaches

    local log="$TmpDir/lat_qd${qd}.log"

    fio --name=lat_qd${qd} --filename="$testfile" --direct=1 \

    --rw=randread --bs=4k --size=64M --numjobs=1 --iodepth=$qd \

    --ioengine=libaio --runtime=15 --thread 2>&1 | tee "$log"



    local avg p50 p99

    avg=$(grep -A1 "lat (" "$log" | grep -oP 'avg=\K[\d.]+' | head -1)

    p50=$(grep "clat percentiles" "$log" -A20 | grep "50.00th" | grep -oP '\[\s*\K\d+' | head -1)

    p99=$(grep "clat percentiles" "$log" -A20 | grep "99.00th" | grep -oP '\[\s*\K\d+' | head -1)

    printf "%-10s %-12s %-12s %-12s\n" "$qd" "${avg:-N/A}" "${p50:-N/A}" "${p99:-N/A}"

    done

    rlPass "latencyvsqueue depthanalysisComplete"

    rlPhaseEnd



    rlPhaseStartTest "latency vs block size (iodepth=16)"

    echo ""

    echo "=== latency vs block size (iodepth=16, randread) ==="

    printf "%-10s %-12s %-12s\n" "BS(K)" "Avg(us)" "IOPS"



    for bs in 4 16 32 64; do

    _fioDropCaches

    local log="$TmpDir/lat_bs${bs}k.log"

    fio --name=lat_bs${bs}k --filename="$testfile" --direct=1 \

    --rw=randread --bs=${bs}k --size=64M --numjobs=1 --iodepth=16 \

    --ioengine=libaio --runtime=10 --thread 2>&1 | tee "$log"



    local avg iops

    avg=$(grep -A1 "lat (" "$log" | grep -oP 'avg=\K[\d.]+' | head -1)

    iops=$(grep "read:" "$log" | grep -oP 'IOPS=\K[\d.]+k?' | head -1)

    printf "%-10s %-12s %-12s\n" "$bs" "${avg:-N/A}" "${iops:-N/A}"

    done

    rlPass "latencyvsblock sizeanalysisComplete"

    rm -f "$testfile"

    rlPhaseEnd



    rlPhaseStartCleanup "Cleanup"

    rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""

    rlPhaseEnd

    rlJournalPrintText

rlJournalEnd

