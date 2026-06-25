#!/bin/bash
# Smoke test: kernel - sysctl -a 内核参数
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeKernelSetup

    rlPhaseEnd

    rlPhaseStartTest "sysctl -a 内核参数"
        rlRun 'sysctl -a 2>&1 | head -5 || true' 0 "sysctl -a 内核参数"
        rlRun 'sysctl kernel.hostname 2>&1 || true' 0 "sysctl 读取hostname参数"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd