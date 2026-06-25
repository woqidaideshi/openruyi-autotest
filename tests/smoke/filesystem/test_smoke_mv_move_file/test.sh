#!/bin/bash
# Smoke test: filesystem - mv move/rename file
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeFSSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "echo 'move me' > old.txt" 0 "创建源文件"
        rlRun "mkdir dest" 0 "创建目标目录"
    rlPhaseEnd

    rlPhaseStartTest "mv 移动/重命名文件"
        rlRun "mv old.txt new.txt" 0 "mv 重命名"
        rlRun "test -f new.txt -a ! -f old.txt" 0 "旧文件已不存在"
        rlRun "mv new.txt dest/" 0 "mv 移动到目录"
        rlRun "test -f dest/new.txt" 0 "文件已移动"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd