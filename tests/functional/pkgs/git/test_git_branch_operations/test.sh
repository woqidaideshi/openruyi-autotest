#!/bin/bash
# Functional test: git - Branch-operations
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        gitSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Branch-operations"
        rlRun "git branch feature" 0 "git branch: create branch"
        rlRun "git branch" 0 "git branch: list branches"
        rlRun "git branch -a" 0 "git branch -a: all branches"
        rlRun "git switch feature" 0 "git switch: switch branch"
        rlRun "git switch -" 0 "git switch -: previous branch"
        rlRun "git branch -d feature" 0 "git branch -d: delete branch"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # git 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
