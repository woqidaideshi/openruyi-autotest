#!/bin/bash
# Compatibility test: LTP POSIX - filesystem/difftime
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../../lib.sh"

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 ltpPosixSetup
 rlPhaseEnd

 rlPhaseStartTest "POSIX Interface: filesystem / difftime"
 rlRun "run_posix_iface_test 'difftime'" 0 "filesystem/difftime Interface conformance test"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd