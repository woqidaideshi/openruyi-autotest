#!/bin/bash
# Smoke test: filesystem - rm delete file and directory
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeFSSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "touch rm_test.txt" 0 "创建测试文件"
        rlRun "mkdir rm_dir" 0 "创建测试目录"
    rlPhaseEnd

    rlPhaseStartTest "rm 删除文件和目录"
        rlRun "rm rm_test.txt" 0 "rm 删除文件"
        rlRun "test ! -f rm_test.txt" 0 "文件已删除"
        rlRun "rm -rf rm_dir" 0 "rm -rf 删除目录"
        rlRun "test ! -d rm_dir" 0 "目录已删除"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd