#!/bin/bash
# Smoke test: text_processing - diff 检测不同
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeTextProcessingSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "echo "a" > f1; echo "b" > f2" 0 "创建测试数据"
        rlRun "echo "a" > f3; echo "a" > f4" 0 "创建测试数据"

    rlPhaseEnd

    rlPhaseStartTest "diff 检测不同"
        rlRun 'diff f1 f2' 1 "diff 检测不同"
        rlRun 'diff f3 f4' 0 "diff 相同文件"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd