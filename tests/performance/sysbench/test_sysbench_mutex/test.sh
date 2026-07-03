#!/bin/bash
# Performance: sysbench - 互斥锁: POSIX mutex 锁竞争压力
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        sysbenchSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 ""
        local cores=$(nproc)
    rlPhaseEnd

    rlPhaseStartTest "互斥锁竞争 (不同锁数量)"
        echo ""
        echo "=== 互斥锁性能 ==="
        printf "%-12s %-15s %-15s %-15s\n" "Mutexes" "eps" "Lat(ms)" "Lock/s"

        for mn in 64 512 1024 2048; do
            local log="/tmp/sb_mutex_${mn}.log"
            sysbench --threads=$cores --mutex-num=$mn --mutex-loops=50000 \
                --mutex-locks=200000 --time=20 --report-interval=5 \
                mutex run 2>&1 | tee "$log"

            local eps lat locks
            eps=$(grep "events per second" "$log" | grep -oP '[\d.]+' | head -1)
            lat=$(grep "95th percentile" "$log" | grep -oP '[\d.]+' | head -1)
            locks=$(grep "total time:" "$log" -A5 | grep "total number" | grep -oP '[\d.]+' | head -1)

            printf "%-12s %-15s %-15s %-15s\n" "$mn" "${eps:-N/A}" "${lat:-N/A}" "${locks:-N/A}"
            rlPass "mutex num=$mn: eps=${eps:-N/A}"
        done
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
        rm -f /tmp/sb_mutex_*.log
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
