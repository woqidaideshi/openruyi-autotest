#!/bin/bash
# Compatibility test: LTP POSIX - signal/sigsuspend
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../../lib.sh"

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 ltpPosixSetup
 rlPhaseEnd

 rlPhaseStartTest "POSIX Interface: signal / sigsuspend"
 rlRun "run_posix_iface_test 'sigsuspend'" 0 "signal/sigsuspend Interface conformance test"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd