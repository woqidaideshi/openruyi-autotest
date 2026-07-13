#!/bin/bash
# Performance: iozone - multifilesizetest (Documentation recommends: 1/2x, 1x, 2x memory)
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 iozoneSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary directory"
 # getmemorysize (MB)
 TOTAL_MEM_MB=$(free -m | awk '/^Mem:/{print $2}')
 rlLogInfo "systemmemory: ${TOTAL_MEM_MB} MB"
 rlPhaseEnd

 rlPhaseStartTest "multifilesizetest"
 local sizes="64 128 256 512"
 local throughputs=()

 for sz in $sizes; do
 local testfile="$TmpDir/iozone_${sz}m.dat"
 local log="$TmpDir/iozone_${sz}m.log"

 sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1 || true
 rlLogInfo "=== testfilesize: ${sz}M ==="

 iozone -c -s ${sz}m -r 16k -f "$testfile" 2>&1 | tee "$log"

 echo ""
 echo "--- IOzone ${sz}M result ---"
 cat "$log"

 # extract write 
 local write_kbps
 write_kbps=$(grep -E '^\s+[0-9]+\s+[0-9]+' "$log" | awk '{print $3}' | head -1)
 if [ -n "$write_kbps" ] && [ "$write_kbps" != "0" ]; then
 throughputs+=("${sz}M:${write_kbps}")
 rlLogInfo "${sz}M Write: ${write_kbps} KB/s"
 fi

 rm -f "$testfile"
 done

 # total
 echo ""
 echo "=== multitesttotal ==="
 for t in "${throughputs[@]}"; do
 echo " $t KB/s"
 done
 if [ ${#throughputs[@]} -gt 0 ]; then
 rlPass "multitestComplete (${#throughputs[@]}/4 hasresult)"
 else
 rlFail "notcan gethasdata"
 fi
 rlPhaseEnd

 rlPhaseStartCleanup "Cleanup"
 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
 rlPhaseEnd
 rlJournalPrintText
rlJournalEnd
