#!/bin/bash
# Functional test: findutils - find-选项
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        findutilsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "find-选项"
        rlRun "find . -maxdepth 1 -name \"*.txt\"" 0 "find -maxdepth: 最大深度"
        rlRun "find . -mindepth 2" 0 "find -mindepth: 最小深度"
        rlRun "find . -empty" 0 "find -empty: 空文件/目录"
        rlRun "find . -size +0c" 0 "find -size: 按大小"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # findutils 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
