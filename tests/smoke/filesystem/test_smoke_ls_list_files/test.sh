#!/bin/bash
# Smoke test: filesystem - ls list files and directories
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeFSSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "echo 'hello' > a.txt" 0 "创建测试文件"
        rlRun "mkdir subdir" 0 "创建测试目录"
    rlPhaseEnd

    rlPhaseStartTest "ls 列出文件和目录"
        rlRun "ls" 0 "ls 列出当前目录"
        rlRun "ls -la" 0 "ls -la 详细列出"
        rlRun "ls -l a.txt" 0 "ls 指定文件"
        rlRun "ls -d subdir" 0 "ls -d 列出目录本身"
        rlRun "ls /tmp" 0 "ls 列出系统目录"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd