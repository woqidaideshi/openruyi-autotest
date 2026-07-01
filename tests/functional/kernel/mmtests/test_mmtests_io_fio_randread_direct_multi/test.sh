#!/bin/bash
# Functional test: kernel - mmtests - io_fio_randread_direct_multi
# MMTests: run-mmtests.sh --config configs/config-io-fio-randread-direct-multi
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        mmtestsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "MMTests - io_fio_randread_direct_multi"
        rlRun "_mmtestsRunCase config-io-fio-randread-direct-multi" 0 "执行 MMTests config-io-fio-randread-direct-multi"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd