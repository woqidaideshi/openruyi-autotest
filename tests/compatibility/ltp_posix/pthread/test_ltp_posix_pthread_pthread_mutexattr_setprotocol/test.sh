#!/bin/bash
# Compatibility test: LTP POSIX - pthread/pthread_mutexattr_setprotocol
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../../lib.sh"

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 ltpPosixSetup
 rlPhaseEnd

 rlPhaseStartTest "POSIX Interface: pthread / pthread_mutexattr_setprotocol"
 rlRun "run_posix_iface_test 'pthread_mutexattr_setprotocol'" 0 "pthread/pthread_mutexattr_setprotocol Interface conformance test"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd