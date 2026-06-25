#!/bin/bash
# Smoke test: text_processing - head 前3行
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeTextProcessingSetup

    rlPhaseEnd

    rlPhaseStartTest "head 前3行"
        rlRun 'head -3 /etc/os-release' 0 "head 前3行"
        rlRun 'tail -3 /etc/os-release' 0 "tail 后3行"
        rlRun 'head -c 10 /etc/hostname' 0 "head 前10字节"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd