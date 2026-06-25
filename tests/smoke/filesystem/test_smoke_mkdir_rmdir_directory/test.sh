#!/bin/bash
# Smoke test: filesystem - mkdir/rmdir directory operations
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeFSSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "mkdir/rmdir 创建删除目录"
        rlRun "mkdir newdir" 0 "mkdir 创建目录"
        rlRun "test -d newdir" 0 "目录存在"
        rlRun "mkdir -p a/b/c" 0 "mkdir -p 创建嵌套目录"
        rlRun "test -d a/b/c" 0 "嵌套目录存在"
        rlRun "rmdir newdir" 0 "rmdir 删除空目录"
        rlRun "mkdir nonempty" 0 "创建非空目录"
        rlRun "touch nonempty/f" 0 "创建目录下文件"
        rlRun "rm -rf nonempty" 0 "rm -rf 删除非空目录"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd