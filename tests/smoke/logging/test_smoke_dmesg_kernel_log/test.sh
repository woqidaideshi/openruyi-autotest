#!/bin/bash
# Smoke test: logging - dmesg kernellog
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeLoggingSetup

 rlPhaseEnd

 rlPhaseStartTest "dmesg kernellog"
 rlRun 'dmesg | head -10' 0 "dmesg kernellog"
 rlRun 'dmesg | wc -l' 0 "dmesg loglinescount"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd