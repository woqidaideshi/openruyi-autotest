#!/bin/bash
# Functional test: sed - 行操作
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        sedSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "行操作"
        rlRun "sed -n \"2p\" lines.txt" 0 "sed -n: 打印指定行"
        rlRun "sed \"2d\" lines.txt" 0 "sed d: 删除指定行"
        rlRun "sed \"2a newline\" lines.txt" 0 "sed a: 追加行"
        rlRun "sed \"2i insertline\" lines.txt" 0 "sed i: 插入行"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # sed 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
