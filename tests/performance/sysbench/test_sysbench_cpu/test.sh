#!/bin/bash
# Performance: sysbench - CPU performance: prime number benchmark
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 sysbenchSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 ""
 rlPhaseEnd

 rlPhaseStartTest "single-core CPU"
 local log="/tmp/sb_cpu_1.log"
 rlLogInfo "=== CPU single-core (--threads=1) ==="
 sysbench --threads=1 --cpu-max-prime=40000 --time=30 --report-interval=5 cpu run 2>&1 | tee "$log"
 _sysbenchParse "$log"
 local eps
 eps=$(grep "events per second" "$log" | grep -oP '[\d.]+' | head -1)
 [ -n "$eps" ] && rlPass "single-core CPU: ${eps} events/s" || rlFail "nodata"
 rlPhaseEnd

 rlPhaseStartTest "multi-core CPU"
 local cores=$(nproc)
 local log="/tmp/sb_cpu_n.log"
 rlLogInfo "=== CPU multi-core (--threads=$cores) ==="
 sysbench --threads=$cores --cpu-max-prime=40000 --time=30 --report-interval=5 cpu run 2>&1 | tee "$log"
 _sysbenchParse "$log"
 local eps
 eps=$(grep "events per second" "$log" | grep -oP '[\d.]+' | head -1)
 [ -n "$eps" ] && rlPass "multi-core CPU ($cores): ${eps} events/s" || rlFail "nodata"
 rlPhaseEnd

 rlPhaseStartTest "single-core vs multi-core comparison"
 local eps1 epsN
 eps1=$(grep "events per second" /tmp/sb_cpu_1.log | grep -oP '[\d.]+' | head -1)
 epsN=$(grep "events per second" /tmp/sb_cpu_n.log | grep -oP '[\d.]+' | head -1)
 if [ -n "$eps1" ] && [ -n "$epsN" ]; then
 rlLogInfo "single-core: ${eps1} eps, multi-core($(nproc)): ${epsN} eps"
 fi
 rlPass "CPU comparisonanalysisComplete"
 rlPhaseEnd

 rlPhaseStartCleanup "Cleanup"
 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
 rm -f /tmp/sb_cpu_*.log
 rlPhaseEnd
 rlJournalPrintText
rlJournalEnd
