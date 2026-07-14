#!/bin/bash

# Reliability: trinity - test 60s

# Documentation recommends: trinity -q -N 99999

. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 trinitySetup

 TmpDir=$(mktemp -d)

 rlRun "cd $TmpDir" 0 "Enter temporary directory"

 # recordtestbeforekernel tainted Status

 TAINT_BEFORE=$(_trinityTaintBefore)

 rlLogInfo "testbefore tainted: $TAINT_BEFORE"

 # Ensure TmpDir canwrite

 chmod 777 "$TmpDir"

 rlPhaseEnd



 rlPhaseStartTest "system callstest"

 local log_file="$TmpDir/trinity_basic.log"

 # by non- root userrun trinity, time 60s

 timeout 70 sudo -u "$TRINITY_USER" trinity -q -N 99999 > "$log_file" 2>&1

 local rc=$?

 rlLogInfo "Trinity exit code: $rc"



 if [ "$rc" -eq 124 ]; then

 rlPass "Trinity by timeout normalterminate (60s post)"

 elif [ "$rc" -eq 0 ]; then

 rlPass "Trinity normalexport (all syscall Complete)"

 else

 rlLogWarning "Trinity non-exit code: $rc"

 fi



 # checkoutput

 rlRun "wc -l < $log_file" 0 "outputlinescountcount"

 _trinityCheckOutput "$log_file"



 # displaypostoutput

 rlRun "tail -20 $log_file" 0 "Trinity post 20 linesoutput"

 rlPhaseEnd



 rlPhaseStartTest "tainted Statuscheck"

 _trinityTaintCheck "$TAINT_BEFORE"

 rlPhaseEnd



 rlPhaseStartCleanup "Cleanup"

 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""

 rlPhaseEnd

 rlJournalPrintText

rlJournalEnd

