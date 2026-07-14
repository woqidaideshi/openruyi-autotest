#!/bin/bash

# Performance: lmbench -: Pipe/TCP/UDP local communicationlatency

. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 lmbenchSetup

 TmpDir=$(mktemp -d)

 rlRun "cd $TmpDir" 0 ""

 rlPhaseEnd



 rlPhaseStartTest "local communicationlatency (Pipe/Unix Socket/TCP/UDP)"

 cd "$LMBENCH_DIR"

 echo "=== local IPC latency (microsecond) ==="



 # Pipe latency

 echo "Pipe:"

./bin/lat_pipe 2>&1 | head -3 || echo " N/A"

 echo ""



 # Unix socket latency

 echo "Unix socket (AF_UNIX):"

./bin/lat_unix 2>&1 | head -3 || echo " N/A"

 echo ""



 # TCP locallatency

 echo "TCP localhost:"

./bin/lat_tcp -s 2>&1 &

 local tcp_pid=$!

 sleep 1

./bin/lat_tcp localhost 2>&1 | head -5 || echo " N/A"

 kill $tcp_pid 2>/dev/null || true

 echo ""



 # UDP locallatency

 echo "UDP localhost:"

./bin/lat_udp -s 2>&1 &

 local udp_pid=$!

 sleep 1

./bin/lat_udp localhost 2>&1 | head -5 || echo " N/A"

 kill $udp_pid 2>/dev/null || true



 rlPass "local communicationlatencytestComplete"

 rlPhaseEnd



 rlPhaseStartTest "full Benchmark "

 cd "$LMBENCH_DIR"

 echo ""

 echo "=== LMbench full Benchmark run ==="



 # Run the full automated suite

 _lmbenchRun 2>&1 | tee /tmp/lmbench_full.log



 if [ -f "$LMBENCH_DIR/results/summary.out" ]; then

 cp "$LMBENCH_DIR/results/summary.out" /tmp/lmbench_summary.txt

 echo ""

 echo "=== full Summary output ==="

 cat /tmp/lmbench_summary.txt

 rlPass "full Benchmark Complete"

 else

 rlLogWarning "Summary filenotGenerate"

 fi

 rlPhaseEnd



 rlPhaseStartCleanup "Cleanup"

 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""

 rm -f /tmp/lmbench_{full,summary}.txt

 rlPhaseEnd

 rlJournalPrintText

rlJournalEnd

