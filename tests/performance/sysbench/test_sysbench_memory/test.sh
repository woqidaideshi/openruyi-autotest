#!/bin/bash

# Performance: sysbench - memorybandwidth: sequential/random read/write

. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 sysbenchSetup

 TmpDir=$(mktemp -d)

 rlRun "cd $TmpDir" 0 ""

 local cores=$(nproc)

 rlPhaseEnd



 rlPhaseStartTest "sequential readwrite (block 1M)"

 echo ""

 echo "=== memorysequential ($cores thread) ==="

 printf "%-12s %-15s\n" "Mode" "MiB/s"



 for op in read write; do

 local log="/tmp/sb_mem_seq_${op}.log"

 sysbench --threads=$cores --memory-block-size=1M --memory-total-size=10000G \

 --memory-oper=$op --memory-access-mode=seq --time=15 \

 --report-interval=5 memory run 2>&1 | tee "$log"



 local bw

 bw=$(grep "MiB/sec" "$log" | grep -oP '[\d.]+' | head -1)

 printf "%-12s %-15s\n" "seq/$op" "${bw:-N/A}"

 rlPass "sequential${op}: ${bw:-N/A} MiB/s"

 done

 rlPhaseEnd



 rlPhaseStartTest "random readwrite (block 8K)"

 echo ""

 echo "=== memoryrandom ($cores thread) ==="

 printf "%-12s %-15s\n" "Mode" "MiB/s"



 for op in read write; do

 local log="/tmp/sb_mem_rnd_${op}.log"

 sysbench --threads=$cores --memory-block-size=8K --memory-total-size=200G \

 --memory-oper=$op --memory-access-mode=rnd --time=15 \

 --report-interval=5 memory run 2>&1 | tee "$log"



 local bw

 bw=$(grep "MiB/sec" "$log" | grep -oP '[\d.]+' | head -1)

 printf "%-12s %-15s\n" "rnd/$op" "${bw:-N/A}"

 rlPass "random${op}: ${bw:-N/A} MiB/s"

 done

 rlPhaseEnd



 rlPhaseStartCleanup "Cleanup"

 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""

 rm -f /tmp/sb_mem_*.log

 rlPhaseEnd

 rlJournalPrintText

rlJournalEnd

