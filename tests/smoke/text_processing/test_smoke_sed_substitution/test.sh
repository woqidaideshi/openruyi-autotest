#!/bin/bash
# Smoke test: text_processing - sed 替换
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeTextProcessingSetup
        rlRun "echo "hello world" | sed 's/world/universe/' | grep universe" 0 "准备环境"

    rlPhaseEnd

    rlPhaseStartTest "sed 替换"
        rlRun 'echo "hello" | sed "s/h/H/"' 0 "sed 替换"
        rlRun 'echo "a b c" | sed "s/ /,/g"' 0 "sed 全局替换"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd