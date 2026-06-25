#!/bin/bash
# Functional test: git - File-modifications
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

    rlPhaseStartTest "File-modifications"
        rlRun "git add file2.txt" 0 "git add: second file"
        rlRun "git commit -m \"add file2\"" 0 "git commit: second commit"
        rlRun "git diff" 0 "git diff: show changes"
        rlRun "git diff --cached" 0 "git diff --cached: staged changes"
        rlRun "git add file1.txt && git commit -m \"modify file1\"" 0 "git commit: modify"
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
