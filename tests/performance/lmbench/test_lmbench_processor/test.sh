#!/bin/bash

# Performance: lmbench - handleandmemorylatency: CPUoperationoverhead + memorylatency

. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    lmbenchSetup

    TmpDir=$(mktemp -d)

    rlRun "cd $TmpDir" 0 ""

    if [ ! -f "$LMBENCH_DIR/bin/lmbench" ]; then

    rlFail "LMbench notcompile"; return 0

    fi

    rlPhaseEnd



    rlPhaseStartTest "handleoperationlatency (null call, signal, fork)"

    cd "$LMBENCH_DIR"

    # runsingletestnon-full

    echo "=== null call latency (system callsoverhead) ==="

./bin/lat_syscall null 2>&1 || true

    echo ""



    echo "=== open/close latency (filesystemcallwith) ==="

./bin/lat_syscall open /tmp 2>&1 || true

    echo ""



    echo "=== signal handlelatency ==="

./bin/lat_sig install 2>&1 || true

    echo ""



    echo "=== fork latency (processcreateoverhead) ==="

./bin/lat_proc fork 2>&1 || true

    echo ""



    echo "=== exec latency ==="

./bin/lat_proc exec 2>&1 || true

    echo ""



    echo "=== shell latency ==="

./bin/lat_proc shell 2>&1 || true



    rlPass "handleoperationlatencytestComplete"

    rlPhaseEnd



    rlPhaseStartTest "memorylatencyanalysis"

    cd "$LMBENCH_DIR"



    # Memory latency with different sizes

    for size in 1M 4M 16M; do

    echo ""

    echo "=== memorylatency (${size}) ==="

./bin/lat_mem_rd ${size} 16 2>&1 | head -5

    done



    # Memory bandwidth

    echo ""

    echo "=== memorybandwidth (bw_mem) ==="

    for op in rd wr rdwr cp fwr frd fcp bzero bcopy; do

    local out

    out=$(./bin/bw_mem 16M "$op" 2>&1 | tail -1)

    if [ -n "$out" ]; then

    echo " $op: $out MB/s"

    fi

    done



    rlPass "memorylatencyanalysisComplete"

    rlPhaseEnd



    rlPhaseStartTest "/floating-point operationslatency"

    cd "$LMBENCH_DIR"

    echo ""

    echo "=== basic arithmeticlatency (seconds) ==="

./bin/lat_ops 2>&1 | head -20

    echo ""



    # Run lat_ops for specific types

    for op in bit add mul div mod; do

    echo -n "int $op: "

./bin/lat_ops -W 5 -N 3 "$op" 2>&1 | grep -oP '[\d.]+' | head -1

    done



    rlPass "latencytestComplete"

    rlPhaseEnd



    rlPhaseStartCleanup "Cleanup"

    rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""

    rlPhaseEnd

    rlJournalPrintText

rlJournalEnd

