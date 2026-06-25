#!/bin/bash
# Smoke test: filesystem - cat read file
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeFSSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "echo 'line1' > f.txt" 0 "创建测试文件"
    rlPhaseEnd

    rlPhaseStartTest "cat 读取和拼接文件"
        rlRun "cat f.txt" 0 "cat 读取文件"
        rlRun "cat /etc/os-release | head -3" 0 "cat 系统文件"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd