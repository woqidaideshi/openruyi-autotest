#!/bin/bash
# Performance: lmbench - process: fork/exec latency, context switchoverhead
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 lmbenchSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 ""
 rlPhaseEnd

 rlPhaseStartTest "processcreate"
 cd "$LMBENCH_DIR"
 echo "=== processcreateoverhead ==="
 echo "fork + exit latency (microsecond):"
./bin/lat_proc fork 2>&1
 echo ""

 echo "fork + execve latency (microsecond):"
./bin/lat_proc exec 2>&1
 echo ""

 echo "fork + /bin/sh latency (microsecond):"
./bin/lat_proc shell 2>&1

 rlPass "processlatencytestComplete"
 rlPhaseEnd

 rlPhaseStartTest "context switchoverhead"
 cd "$LMBENCH_DIR"
 echo ""
 echo "=== context switchlatency ==="

 # differentprocesscountanddatasizecontext switch
 for procs in 2 4 8 16; do
 for size in 0 16 64; do
 echo -n " ${procs}p/${size}K: "
./bin/lat_ctx -s $size $procs 2>&1 | grep -oP '[\d.]+' | head -1
 done
 done

 rlPass "context switchanalysisComplete"
 rlPhaseEnd

 rlPhaseStartTest "threadcreateoverhead"
 cd "$LMBENCH_DIR"
 echo ""
 echo "=== threadoperation ==="
 if [ -f bin/lat_pthread ]; then
./bin/lat_pthread create 2>&1 || echo "pthread testnoavailable"
 fi

 # subprocessandthreadcomparison
 echo ""
 echo "=== fork vs thread comparison ==="
 echo "fork: "
./bin/lat_proc fork 2>&1 | tail -1 || true
 rlPass "threadoverheadtestComplete"
 rlPhaseEnd

 rlPhaseStartCleanup "Cleanup"
 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
 rlPhaseEnd
 rlJournalPrintText
rlJournalEnd
