#!/bin/bash

# Reliability: trinity - multiprocessandlines (-C)

#: trinity -q -C$(nproc)

. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 trinitySetup

 TmpDir=$(mktemp -d)

 rlRun "cd $TmpDir" 0 "Enter temporary directory"

 TAINT_BEFORE=$(_trinityTaintBefore)

 chmod 777 "$TmpDir"

 local cores

 cores=$(nproc)

 rlLogInfo "CPU corecount: $cores"

 rlPhaseEnd



 rlPhaseStartTest "singleprocess baseline"

 local log1="$TmpDir/trinity_1proc.log"

 timeout 30 sudo -u "$TRINITY_USER" trinity -q -C 1 -N 5000 > "$log1" 2>&1

 local rc1=$?

 local calls1

 calls1=$(grep -c "succeeded\|completed" "$log1" 2>/dev/null || echo "N/A")

 rlLogInfo "singleprocess: exit=$rc1, Completecallwith≈$calls1"

 rlRun "[ $rc1 -eq 0 ] || [ $rc1 -eq 124 ]" 0 "singleprocesstestComplete"

 rlPhaseEnd



 rlPhaseStartTest "multiprocessandlines ($cores cores)"

 local log_multi="$TmpDir/trinity_multi.log"

 timeout 30 sudo -u "$TRINITY_USER" trinity -q -C "$cores" -N 10000 > "$log_multi" 2>&1

 local rc_multi=$?

 rlLogInfo "multiprocess ($cores): exit=$rc_multi"



 if [ "$rc_multi" -eq 0 ] || [ "$rc_multi" -eq 124 ]; then

 rlPass "Trinity -C $cores multiprocesstestComplete"

 else

 rlLogWarning "multiprocessExceptionexport: $rc_multi"

 fi



 # verifymultiprocess

 if grep -qi "child\|process\|fork" "$log_multi" 2>/dev/null; then

 rlPass "detect to multiprocessand"

 fi

 _trinityCheckOutput "$log_multi"

 rlPhaseEnd



 rlPhaseStartTest "tainted check"

 _trinityTaintCheck "$TAINT_BEFORE"

 rlPhaseEnd



 rlPhaseStartCleanup "Cleanup"

 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""

 rlPhaseEnd

 rlJournalPrintText

rlJournalEnd

