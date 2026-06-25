#!/bin/bash
# Smoke test: text_processing - find 按名称查找
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeTextProcessingSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "touch found.txt; mkdir sub" 0 "创建测试数据"

    rlPhaseEnd

    rlPhaseStartTest "find 按名称查找"
        rlRun 'find . -name "found.txt"' 0 "find 按名称查找"
        rlRun 'find . -type d' 0 "find 按类型查目录"
        rlRun 'find . -type f' 0 "find 按类型查文件"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd