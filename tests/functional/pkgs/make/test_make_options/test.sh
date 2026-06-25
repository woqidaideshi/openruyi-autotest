#!/bin/bash
# Functional test: make - Options
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        makeSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Options"
        rlRun "make -n" 0 "make -n: dry run"
        rlRun "make -B" 0 "make -B: always make"
        rlRun "make --just-print" 0 "make --just-print"
        rlRun "make -d 2>&1 | head -5" 0 "make -d: debug output"
        rlRun "make --debug=b 2>&1 | head -5" 0 "make --debug=b: basic debug"
        rlRun "make -q" 0 "make -q: question mode"
        rlRun "make -s" 0 "make -s: silent"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # make 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
