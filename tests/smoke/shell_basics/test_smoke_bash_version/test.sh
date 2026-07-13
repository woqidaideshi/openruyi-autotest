#!/bin/bash
# Smoke test: shell_basics - bash version
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeShellBasicsSetup

 rlPhaseEnd

 rlPhaseStartTest "bash version"
 rlRun 'bash --version' 0 "bash version"
 rlRun 'bash -c "echo shell works"' 0 "bash -c Executecommand"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd