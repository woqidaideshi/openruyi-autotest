#!/bin/bash
# Smoke test: shell_basics - for loop normal
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeShellBasicsSetup
 rlRun "for i in 1 2 3; do echo $i; done | grep -q 2" 0 "Prepare environment"
 rlRun "n=0; while [ $n -lt 3 ]; do n=$((n+1)); done; test $n -eq 3" 0 "Prepare environment"

 rlPhaseEnd

 rlPhaseStartTest "for loop normal"
 rlRun 'echo ok' 0 "for loop normal"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd