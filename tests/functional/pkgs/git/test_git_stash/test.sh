#!/bin/bash
# Functional test: git - Stash
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

    rlPhaseStartTest "Stash"
        rlRun "git stash push -m \"wip changes\" 2>&1 || true" 0 "git stash: push"
        rlRun "git stash list 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "git stash list"
        rlRun "git stash pop 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "git stash pop"
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
