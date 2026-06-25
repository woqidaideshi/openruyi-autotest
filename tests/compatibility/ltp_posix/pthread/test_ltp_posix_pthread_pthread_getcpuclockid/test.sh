#!/bin/bash
# Compatibility test: LTP POSIX - pthread/pthread_getcpuclockid
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../../lib.sh"

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        ltpPosixSetup
    rlPhaseEnd

    rlPhaseStartTest "POSIX 接口: pthread / pthread_getcpuclockid"
        rlRun "run_posix_iface_test 'pthread_getcpuclockid'" 0 "pthread/pthread_getcpuclockid 接口一致性测试"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd