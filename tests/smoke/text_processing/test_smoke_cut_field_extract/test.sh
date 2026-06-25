#!/bin/bash
# Smoke test: text_processing - cut 提取第一字段
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeTextProcessingSetup
        rlRun "echo "a:b:c:d" | cut -d: -f1,3 | grep "a:c"" 0 "准备环境"

    rlPhaseEnd

    rlPhaseStartTest "cut 提取第一字段"
        rlRun 'echo "user:x:1000" | cut -d: -f1' 0 "cut 提取第一字段"
        rlRun 'echo "hello" | cut -c1-3' 0 "cut 按字符位置"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd