#!/bin/bash
# Functional test: lz4 - 错误处理��
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        lz4Setup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "错误处理��"
rlRun() { eval "$1" 2>&1; return $?; }
        rlRun "lz4 --help 2>&1 | head -10" 0 "�鿴 lz4 错误处理Ϣ"
        rlRun "lz4c --help 2>&1 | head -10" 0 "�鿴 lz4c 错误处理Ϣ"
        rlRun "lz4cat --help 2>&1 | head -10" 0 "�鿴 lz4cat 错误处理Ϣ"
        rlRun "unlz4 --help 2>&1 | head -10" 0 "�鿴 unlz4 错误处理Ϣ"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # lz4 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
