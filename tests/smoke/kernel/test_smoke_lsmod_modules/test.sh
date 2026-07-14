#!/bin/bash
# Smoke test: kernel - lsmod list modules
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    smokeKernelSetup

    rlPhaseEnd

    rlPhaseStartTest "lsmod list modules"
    rlRun 'lsmod | head -10' 0 "lsmod list modules"
    rlRun 'lsmod | wc -l' 0 "lsmod modulecount"
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd