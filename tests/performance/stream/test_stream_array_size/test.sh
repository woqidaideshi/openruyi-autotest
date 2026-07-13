#!/bin/bash
# Performance: stream - countgroupsize: Measure L1/L2/L3/DRAM memorybandwidth
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 streamSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 ""
 # getsize
 local l1_kb l2_kb l3_kb
 l1_kb=$(lscpu 2>/dev/null | grep "L1d cache" | grep -oP '\d+' | head -1)
 l2_kb=$(lscpu 2>/dev/null | grep "L2 cache" | grep -oP '\d+' | head -1)
 l3_kb=$(lscpu 2>/dev/null | grep "L3 cache" | grep -oP '\d+' | head -1)
 rlLogInfo "L1d: ${l1_kb:-?}KB, L2: ${l2_kb:-?}KB, L3: ${l3_kb:-?}KB"
 if [ ! -f "$STREAM_DIR/stream.c" ]; then
 rlFail "stream.c does not exist"; return 0
 fi
 rlPhaseEnd

 rlPhaseStartTest "differentcountgroupsizecompilerun"
 echo ""
 echo "=== countgroupsize vs memorybandwidth (single-core TRIAD) ==="
 printf "%-15s %-15s %-10s\n" "ArraySize" "Triad(MB/s)" "FitIn"

 # testdifferentcountgroupsize: 10K ~ 10M 
 for elems in 10000 100000 500000 1000000 5000000 10000000; do
 local name="stream_${elems}"
 local log="/tmp/${name}.log"

 # compile
 gcc -O3 -DSTREAM_ARRAY_SIZE=$elems -DNTIMES=10 \
 "$STREAM_DIR/stream.c" -o "$name" -lm 2>/dev/null
 if [ ! -x "$name" ]; then continue; fi

 # run
 OMP_NUM_THREADS=1./"$name" > "$log" 2>&1
 local triad
 triad=$(grep "^Triad:" "$log" | awk '{print $2}' | head -1)

 # datain
 local bytes=$((elems * 8 * 3)) # 3 arrays × 8 bytes
 local fit="DRAM"
 if [ -n "$l3_kb" ] && [ "$bytes" -le $((l3_kb * 1024)) ]; then fit="L3"; fi
 if [ -n "$l2_kb" ] && [ "$bytes" -le $((l2_kb * 1024)) ]; then fit="L2"; fi
 if [ -n "$l1_kb" ] && [ "$bytes" -le $((l1_kb * 1024)) ]; then fit="L1"; fi

 printf "%-15s %-15s %-10s\n" "$elems" "${triad:-N/A}" "$fit"
 rm -f "$name"
 done
 rlPass "countgroupsizeanalysisComplete"
 rlPhaseEnd

 rlPhaseStartCleanup "Cleanup"
 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
 rm -f /tmp/stream_*.log
 rlPhaseEnd
 rlJournalPrintText
rlJournalEnd
