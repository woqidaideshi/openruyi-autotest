#!/bin/bash
# Smoke test: dev_tools - python3 available
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    smokeDevToolsSetup

    rlPhaseEnd

    rlPhaseStartTest "python3 available"
    rlRun 'which python3' 0 "python3 available"
    rlRun 'python3 --version' 0 "python3 version"
    rlRun 'python3 -c "print(1+1)"' 0 "python3 basic arithmetic"
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd