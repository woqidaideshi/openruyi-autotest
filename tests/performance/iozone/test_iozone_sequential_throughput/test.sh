#!/bin/bash
# Performance: iozone - sequential readwrite
# Measureoperationsystem IO stackinsequential readwrite
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 iozoneSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary directory"
 sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1 || true
 rlPhaseEnd

 rlPhaseStartTest "sequential write throughput"
 local testfile="$TmpDir/seq_write.dat"
 local log="$TmpDir/seq_write.log"

 # onlywithwriteoperation (-i 0), recordsize, testfilesequential write
 iozone -c -s 256m -r 64k -i 0 -f "$testfile" 2>&1 | tee "$log"

 echo ""
 echo "=== sequential writeresult (256M, 64K record) ==="
 cat "$log"

 local write_kbps
 write_kbps=$(grep -E '^\s+[0-9]+\s+[0-9]+' "$log" | awk '{print $3}' | head -1)
 if [ -n "$write_kbps" ] && [ "$write_kbps" != "0" ]; then
 local write_mbps
 write_mbps=$(awk "BEGIN {printf \"%.1f\", ${write_kbps}/1024}" 2>/dev/null)
 rlLogInfo "sequential write throughput: ${write_mbps} MB/s (${write_kbps} KB/s)"
 rlPass "sequential write: ${write_mbps} MB/s"
 else
 rlFail "notget to sequential writedata"
 fi
 rm -f "$testfile"
 rlPhaseEnd

 rlPhaseStartTest "sequential read throughput"
 # writefile, sequential read
 local testfile="$TmpDir/seq_read.dat"
 local log="$TmpDir/seq_read.log"

 # prewritefile
 dd if=/dev/zero of="$testfile" bs=1M count=256 2>/dev/null
 sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1 || true

 # onlywithreadoperation (-i 1)
 iozone -c -s 256m -r 64k -i 1 -f "$testfile" 2>&1 | tee "$log"

 echo ""
 echo "=== sequential readresult (256M, 64K record) ==="
 cat "$log"

 local read_kbps
 read_kbps=$(grep -E '^\s+[0-9]+\s+[0-9]+' "$log" | awk '{print $5}' | head -1)
 if [ -n "$read_kbps" ] && [ "$read_kbps" != "0" ]; then
 local read_mbps
 read_mbps=$(awk "BEGIN {printf \"%.1f\", ${read_kbps}/1024}" 2>/dev/null)
 rlLogInfo "sequential read throughput: ${read_mbps} MB/s (${read_kbps} KB/s)"
 rlPass "sequential read: ${read_mbps} MB/s"
 else
 rlFail "notget to sequential readdata"
 fi
 rm -f "$testfile"
 rlPhaseEnd

 rlPhaseStartTest "read/write ratioanalysis"
 # simultaneouslyreadwrite, readwrite
 local testfile="$TmpDir/rw_ratio.dat"
 local log="$TmpDir/rw_ratio.log"

 sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1 || true
 iozone -c -s 128m -r 64k -i 0 -i 1 -f "$testfile" 2>&1 | tee "$log"

 local w r
 w=$(grep -E '^\s+[0-9]+\s+[0-9]+' "$log" | awk '{print $3}' | head -1)
 r=$(grep -E '^\s+[0-9]+\s+[0-9]+' "$log" | awk '{print $5}' | head -1)

 if [ -n "$w" ] && [ -n "$r" ] && [ "$w" != "0" ]; then
 local ratio
 ratio=$(awk "BEGIN {printf \"%.2f\", ${r}/${w}}" 2>/dev/null)
 rlLogInfo "read/write: ${ratio}x (read=${r} write=${w} KB/s)"
 fi
 rlPass "read/write ratioanalysisComplete"
 rm -f "$testfile"
 rlPhaseEnd

 rlPhaseStartCleanup "Cleanup"
 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
 rlPhaseEnd
 rlJournalPrintText
rlJournalEnd
