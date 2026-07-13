#!/bin/bash
# Reliability: trinity - full-speed stresstest
# Documentation recommends: trinity -qq -l off -C$(nproc)
# logandremainingoutput, run
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
 rlPhaseEnd

 rlPhaseStartTest "mode -qq -l off"
 local log="$TmpDir/trinity_stress.log"
 # Documentation recommends: trinity -qq -l off -C$(nproc)
 timeout 45 sudo -u "$TRINITY_USER" trinity -qq -l off -C "$cores" > "$log" 2>&1
 local rc=$?

 rlLogInfo "testexit code: $rc"

 if [ "$rc" -eq 124 ]; then
 rlPass "full-speed stresstest timeout Complete (45s, $cores process)"
 elif [ "$rc" -eq 0 ]; then
 rlPass "full-speed stresstestnormalComplete"
 else
 # checkwhetherissignalterminate (137 = SIGKILL, 143 = SIGTERM)
 if [ "$rc" -eq 137 ] || [ "$rc" -eq 143 ]; then
 rlLogWarning "mode by signalterminate: $rc"
 else
 rlLogWarning "modeExceptionexport: $rc"
 fi
 fi

 # outputcount
 rlRun "wc -l < $log 2>/dev/null || echo 0" 0 "outputlinescount"
 rlRun "tail -10 $log 2>/dev/null || echo empty" 0 "postoutput"

 # checkException
 _trinityCheckOutput "$log"
 rlPhaseEnd

 rlPhaseStartTest "tainted check"
 _trinityTaintCheck "$TAINT_BEFORE"
 rlPhaseEnd

 rlPhaseStartCleanup "Cleanup"
 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
 rlPhaseEnd
 rlJournalPrintText
rlJournalEnd
