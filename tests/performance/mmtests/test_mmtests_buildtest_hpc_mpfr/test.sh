#!/bin/bash
# Functional test: kernel - mmtests - buildtest_hpc_mpfr
# MMTests: run-mmtests.sh --config configs/config-buildtest-hpc-mpfr
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        mmtestsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "MMTests - buildtest_hpc_mpfr"
        rlRun "_mmtestsRunCase config-buildtest-hpc-mpfr" 0 "执行 MMTests config-buildtest-hpc-mpfr"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd