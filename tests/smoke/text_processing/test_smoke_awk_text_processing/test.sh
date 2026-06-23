#!/bin/bash
# Smoke test: text_processing - awk 打印第一列
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeTextProcessingSetup
        rlRun "echo "a 1" 0 "准备环境"
        rlRun "b 2" 0 "准备环境"
        rlRun "c 3" > data.txt" 0 "准备环境"
        rlRun "rm -f data.txt" 0 "准备环境"

    rlPhaseEnd

    rlPhaseStartTest "awk 打印第一列"
        rlRun 'awk "{print \$1}" data.txt' 0 "awk 打印第一列"
        rlRun 'awk "{print \$2}" data.txt' 0 "awk 打印第二列"
        rlRun 'awk "{sum+=\$2} END{print sum}" data.txt' 0 "awk 求和"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd