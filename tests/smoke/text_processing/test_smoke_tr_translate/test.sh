#!/bin/bash
# Smoke test: text_processing - tr 大小写转换
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeTextProcessingSetup

    rlPhaseEnd

    rlPhaseStartTest "tr 大小写转换"
        rlRun 'echo "HELLO" | tr "A-Z" "a-z"' 0 "tr 大小写转换"
        rlRun 'echo "a b c" | tr -d " "' 0 "tr -d 删除空格"
        rlRun 'echo "a  b   c" | tr -s " "' 0 "tr -s 压缩重复空格"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd