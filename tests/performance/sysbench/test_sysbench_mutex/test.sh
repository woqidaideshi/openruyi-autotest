#!/bin/bash

# Performance: sysbench -: POSIX mutex stress

. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 sysbenchSetup

 TmpDir=$(mktemp -d)

 rlRun "cd $TmpDir" 0 ""

 local cores=$(nproc)

 rlPhaseEnd



 rlPhaseStartTest " (different lock counts)"

 echo ""

 echo "=== performance ==="

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



 rlPhaseStartCleanup "Cleanup"

 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""

 rm -f /tmp/sb_mutex_*.log

 rlPhaseEnd

 rlJournalPrintText

rlJournalEnd

