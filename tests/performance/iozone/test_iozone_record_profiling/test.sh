#!/bin/bash
# Performance: iozone - outputresolve: analysiseach type I/O operationperformance
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 iozoneSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary directory"
 sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1 || true
 rlPhaseEnd

 rlPhaseStartTest "all modes I/O test"
 local testfile="$TmpDir/iozone_full.dat"
 local log="$TmpDir/iozone_full.log"

 # -i 0=write/rewrite, 1=read/reread, 2=random-read/write
 rlRun "iozone -c -s 128m -r 8k -i 0 -i 1 -i 2 -f $testfile 2>&1 | tee $log" 0 "all modestest (-i 0 -i 1 -i 2)"

 echo ""
 echo "=== IOzone all modesoutput ==="
 cat "$log"
 echo "=== output end ==="
 echo ""

 # resolveeach operation
 _iozoneParseOutput "$log"
 rlPhaseEnd

 rlPhaseStartTest "differentrecordsizecomparison"
 local rec_sizes="4 16 64 256 1024"
 echo ""
 echo "=== recordsize vs ==="
 printf "%-10s %-15s %-15s\n" "record(K)" "Write(KB/s)" "Read(KB/s)"

 for rs in $rec_sizes; do
 local testfile="$TmpDir/iozone_r${rs}k.dat"
 local log="$TmpDir/iozone_r${rs}k.log"

 sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1 || true
 iozone -c -s 64m -r ${rs}k -i 0 -i 1 -f "$testfile" 2>&1 | tee "$log"

 local w r
 w=$(grep -E '^\s+[0-9]+\s+[0-9]+' "$log" | awk '{print $3}' | head -1)
 r=$(grep -E '^\s+[0-9]+\s+[0-9]+' "$log" | awk '{print $5}' | head -1)
 printf "%-10s %-15s %-15s\n" "$rs" "${w:-N/A}" "${r:-N/A}"

 rm -f "$testfile"
 done

 rlPass "recordsizecomparisonComplete"
 rlPhaseEnd

 rlPhaseStartCleanup "Cleanup"
 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
 rlPhaseEnd
 rlJournalPrintText
rlJournalEnd
