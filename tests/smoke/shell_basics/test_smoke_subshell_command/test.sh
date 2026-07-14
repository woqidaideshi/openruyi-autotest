#!/bin/bash
# Smoke test: shell_basics - \$() commandreplace
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    smokeShellBasicsSetup
    rlRun "X=$(date +%Y); test -n "$X"" 0 "Prepare environment"

    rlPhaseEnd

    rlPhaseStartTest "\$() commandreplace"
    rlRun 'echo $(uname)' 0 "\$() commandreplace"
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd