#!/bin/bash
# Smoke test: shell_basics - 管道 | 连接命令
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeShellBasicsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "echo "data" > out.txt" 0 "创建测试数据"
        rlRun "echo "more" >> out.txt" 0 "创建测试数据"

    rlPhaseEnd

    rlPhaseStartTest "管道 | 连接命令"
        rlRun 'cat out.txt | wc -l' 0 "管道 | 连接命令"
        rlRun 'wc -l < out.txt' 0 "重定向 < 输入"
        rlRun 'grep data out.txt > /dev/null 2>&1' 0 "重定向到 /dev/null"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd