#!/bin/bash

# Performance: sysbench - threadscheduler: threadcreate/ + 

. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    sysbenchSetup

    TmpDir=$(mktemp -d)

    rlRun "cd $TmpDir" 0 ""

    local cores=$(nproc)

    rlPhaseEnd



    rlPhaseStartTest "threadstress (different lock counts)"

    echo ""

    echo "=== threadschedulerperformance ==="

    printf "%-10s %-12s %-15s %-15s\n" "Locks" "eps" "Lat(ms)" "Fairness"



    for locks in 8 $cores $((cores * 2)); do

    local log="/tmp/sb_threads_${locks}.log"

    sysbench --threads=$cores --thread-locks=$locks --time=30 \

    --report-interval=5 threads run 2>&1 | tee "$log"



    local eps lat fair

    eps=$(grep "events per second" "$log" | grep -oP '[\d.]+' | head -1)

    lat=$(grep "95th percentile" "$log" | grep -oP '[\d.]+' | head -1)

    fair=$(grep "execution time" "$log" -A1 | grep "avg/stddev" | grep -oP '[\d.]+/[\d.]+' | head -1)



    printf "%-10s %-12s %-15s %-15s\n" "$locks" "${eps:-N/A}" "${lat:-N/A}" "${fair:-N/A}"

    rlPass "threads locks=$locks: eps=${eps:-N/A}"

    done

    rlPhaseEnd



    rlPhaseStartCleanup "Cleanup"

    rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""

    rm -f /tmp/sb_threads_*.log

    rlPhaseEnd

    rlJournalPrintText

rlJournalEnd

