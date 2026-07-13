#!/bin/bash
# Performance: stream - single-corememorybandwidth: COPY/SCALE/ADD/TRIAD itemsoperation
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 streamSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary directory"
 rlLogInfo "CPU corecount: $(nproc)"
 lscpu 2>/dev/null | grep -i "cache\|model name" | head -10
 rlPhaseEnd

 rlPhaseStartTest "single-core COPY (1R+1W)"
 local log="/tmp/stream_copy.log"
 export OMP_NUM_THREADS=1
 _streamRun 1 > "$log" 2>&1
 rlRun "cat $log" 0 "STREAM COPY full output"
 local bw
 bw=$(grep "^Copy:" "$log" | awk '{print $2}' | head -1)
 if [ -n "$bw" ] && [ "$bw" != "0" ]; then
 rlPass "COPY: ${bw} MB/s"
 else
 rlFail "COPY notreturnhasdata"
 fi
 rlPhaseEnd

 rlPhaseStartTest "single-core SCALE (1R+1W)"



 local log="/tmp/stream_scale.log"
 export OMP_NUM_THREADS=1
 _streamRun 1 > "$log" 2>&1
 rlRun "cat $log" 0 "STREAM SCALE full output"
 local bw
 bw=$(grep "^Scale:" "$log" | awk '{print $2}' | head -1)
 [ -n "$bw" ] && [ "$bw" != "0" ] && rlPass "SCALE: ${bw} MB/s" || rlFail "SCALE nodata"
 rlPhaseEnd

 rlPhaseStartTest "single-core ADD (2R+1W)"
 local log="/tmp/stream_add.log"
 export OMP_NUM_THREADS=1
 _streamRun 1 > "$log" 2>&1
 rlRun "cat $log" 0 "STREAM ADD full output"
 local bw
 bw=$(grep "^Add:" "$log" | awk '{print $2}' | head -1)
 [ -n "$bw" ] && [ "$bw" != "0" ] && rlPass "ADD: ${bw} MB/s" || rlFail "ADD nodata"
 rlPhaseEnd

 rlPhaseStartTest "single-core TRIAD (2R+1W,)"
 local log="/tmp/stream_triad.log"
 export OMP_NUM_THREADS=1
 _streamRun 1 > "$log" 2>&1
 echo ""
 echo "=== STREAM single-corefullresult ==="
 cat "$log"
 _streamParseResult "$log"

 local bw
 bw=$(grep "^Triad:" "$log" | awk '{print $2}' | head -1)
 if [ -n "$bw" ] && [ "$bw" != "0" ]; then
 rlPass "single-core TRIAD: ${bw} MB/s (corememorybandwidth)"
 else
 rlFail "TRIAD notreturndata"
 fi
 rlPhaseEnd

 rlPhaseStartCleanup "Cleanup"
 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
 rm -f /tmp/stream_{copy,scale,add,triad}.log
 rlPhaseEnd
 rlJournalPrintText
rlJournalEnd
