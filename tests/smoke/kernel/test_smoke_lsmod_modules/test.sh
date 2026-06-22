#!/bin/bash
# Smoke test: kernel - lsmod 列出模块
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeKernelSetup

    rlPhaseEnd

    rlPhaseStartTest "lsmod 列出模块"
        rlRun 'lsmod | head -10' 0 "lsmod 列出模块"
        rlRun 'lsmod | wc -l' 0 "lsmod 模块数量"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd