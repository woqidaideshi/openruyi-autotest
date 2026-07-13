#!/bin/bash
# Performance: stream - compilecomparison: GCC vs Clang Generatememorybandwidthdiff
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 streamSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 ""
 if [ ! -f "$STREAM_DIR/stream.c" ]; then
 rlFail "stream.c does not exist"; return 0
 fi
 # clang
 if ! command -v clang >/dev/null 2>&1; then
 echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf install -y clang 2>/dev/null
 fi
 local elems
 elems=$(grep "^array_size=" "$STREAM_FLAG" 2>/dev/null | cut -d= -f2)
 if [ -z "$elems" ]; then elems=10000000; fi
 rlLogInfo "testcountgroupsize: $elems"
 rlPhaseEnd

 rlPhaseStartTest "GCC -O3 vs Clang -O3 comparison"
 echo ""
 echo "=== GCC vs Clang memorybandwidthcomparison ==="
 printf "%-10s %-12s %-12s %-12s %-12s\n" "Compiler" "Copy" "Scale" "Add" "Triad"

 for compiler in gcc clang; do
 local bin="stream_${compiler}"
 "$compiler" -O3 -fopenmp -DSTREAM_ARRAY_SIZE=$elems -DNTIMES=15 \
 "$STREAM_DIR/stream.c" -o "$bin" -lm 2>/dev/null

 if [ -x "$bin" ]; then
 local log="/tmp/stream_${compiler}.log"
 OMP_NUM_THREADS=1./"$bin" > "$log" 2>&1

 local copy scale add triad
 copy=$(grep "^Copy:" "$log" | awk '{print $2}' | head -1)
 scale=$(grep "^Scale:" "$log" | awk '{print $2}' | head -1)
 add=$(grep "^Add:" "$log" | awk '{print $2}' | head -1)
 triad=$(grep "^Triad:" "$log" | awk '{print $2}' | head -1)

 printf "%-10s %-12s %-12s %-12s %-12s\n" "$compiler" \
 "${copy:-N/A}" "${scale:-N/A}" "${add:-N/A}" "${triad:-N/A}"

 # outputfullresult
 echo "--- ${compiler} full output ---"
 grep -E "^(Copy|Scale|Add|Triad):" "$log"
 rlPass "${compiler}: TRIAD=${triad:-N/A} MB/s"
 else
 rlFail "${compiler} Compile failed"
 fi
 rm -f "$bin"
 done
 rlPhaseEnd

 rlPhaseStartTest "GCC differentoptimizationlevel (-O2 vs -O3 vs -Ofast)"
 echo ""
 echo "=== GCC optimizationlevelcomparison ==="
 printf "%-10s %-12s %-12s %-12s %-12s\n" "Opt" "Copy" "Scale" "Add" "Triad"

 for opt in O2 O3 Ofast; do
 local bin="stream_gcc_${opt}"
 gcc -${opt} -fopenmp -DSTREAM_ARRAY_SIZE=$elems -DNTIMES=15 \
 "$STREAM_DIR/stream.c" -o "$bin" -lm 2>/dev/null

 if [ -x "$bin" ]; then
 local log="/tmp/stream_gcc_${opt}.log"
 OMP_NUM_THREADS=1./"$bin" > "$log" 2>&1

 local copy scale add triad
 copy=$(grep "^Copy:" "$log" | awk '{print $2}' | head -1)
 scale=$(grep "^Scale:" "$log" | awk '{print $2}' | head -1)
 add=$(grep "^Add:" "$log" | awk '{print $2}' | head -1)
 triad=$(grep "^Triad:" "$log" | awk '{print $2}' | head -1)

 printf "%-10s %-12s %-12s %-12s %-12s\n" "-${opt}" \
 "${copy:-N/A}" "${scale:-N/A}" "${add:-N/A}" "${triad:-N/A}"
 rlPass "GCC -${opt}: TRIAD=${triad:-N/A}"
 fi
 rm -f "$bin"
 done
 rlPhaseEnd

 rlPhaseStartCleanup "Cleanup"
 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
 rm -f /tmp/stream_{gcc,clang,gcc_O?}.log
 rlPhaseEnd
 rlJournalPrintText
rlJournalEnd
