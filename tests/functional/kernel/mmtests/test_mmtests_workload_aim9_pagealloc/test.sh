#!/bin/bash
# Functional test: kernel - mmtests - workload_aim9_pagealloc
# MMTests: run-mmtests.sh --config configs/config-workload-aim9-pagealloc
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        mmtestsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "MMTests - workload_aim9_pagealloc"
        rlRun "_mmtestsRunCase config-workload-aim9-pagealloc" 0 "执行 MMTests config-workload-aim9-pagealloc"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd