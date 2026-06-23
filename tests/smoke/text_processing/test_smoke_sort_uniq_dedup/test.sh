#!/bin/bash
# Smoke test: text_processing - sort 排序
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeTextProcessingSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "cat > nums.txt << EOF" 0 "创建测试数据"
        rlRun "3" 0 "创建测试数据"
        rlRun "1" 0 "创建测试数据"
        rlRun "2" 0 "创建测试数据"
        rlRun "1" 0 "创建测试数据"
        rlRun "3" 0 "创建测试数据"
        rlRun "EOF" 0 "创建测试数据"

    rlPhaseEnd

    rlPhaseStartTest "sort 排序"
        rlRun 'sort nums.txt' 0 "sort 排序"
        rlRun 'sort -n nums.txt' 0 "sort -n 数值排序"
        rlRun 'sort nums.txt | uniq' 0 "sort|uniq 去重"
        rlRun 'sort nums.txt | uniq | wc -l' 0 "去重后仅3行"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd