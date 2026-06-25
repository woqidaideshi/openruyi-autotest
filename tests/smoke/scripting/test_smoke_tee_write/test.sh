#!/bin/bash
# Smoke test: scripting - tee 写入文件
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeScriptingSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "echo "data" | tee out.txt > /dev/null" 0 "创建测试数据"

    rlPhaseEnd

    rlPhaseStartTest "tee 写入文件"
        rlRun 'test -f out.txt' 0 "tee 写入文件"
        rlRun 'grep data out.txt' 0 "tee 内容正确"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd