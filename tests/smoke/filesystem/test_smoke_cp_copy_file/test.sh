#!/bin/bash
# Smoke test: filesystem - cp copy file and directory
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeFSSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "echo 'data' > src.txt" 0 "创建源文件"
        rlRun "mkdir sub" 0 "创建源目录"
        rlRun "echo 'nested' > sub/f.txt" 0 "创建子文件"
    rlPhaseEnd

    rlPhaseStartTest "cp 复制文件和目录"
        rlRun "cp src.txt dst.txt" 0 "cp 复制文件"
        rlRun "diff src.txt dst.txt" 0 "验证复制一致"
        rlRun "cp -r sub sub2" 0 "cp -r 递归复制目录"
        rlRun "test -f sub2/f.txt" 0 "子目录文件存在"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd