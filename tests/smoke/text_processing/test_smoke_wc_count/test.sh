#!/bin/bash
# Smoke test: text_processing - wc -l 统计行数
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeTextProcessingSetup

    rlPhaseEnd

    rlPhaseStartTest "wc -l 统计行数"
        rlRun 'wc -l /etc/os-release' 0 "wc -l 统计行数"
        rlRun 'wc -c /etc/hostname' 0 "wc -c 统计字节数"
        rlRun 'wc -w /etc/os-release' 0 "wc -w 统计单词数"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd