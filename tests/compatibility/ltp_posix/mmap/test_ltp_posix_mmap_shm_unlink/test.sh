#!/bin/bash
# Compatibility test: LTP POSIX - mmap/shm_unlink
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../../lib.sh"

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        ltpPosixSetup
    rlPhaseEnd

    rlPhaseStartTest "POSIX 接口: mmap / shm_unlink"
        rlRun "run_posix_iface_test 'shm_unlink'" 0 "mmap/shm_unlink 接口一致性测试"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd