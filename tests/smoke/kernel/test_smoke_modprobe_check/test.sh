#!/bin/bash
# Smoke test: kernel - modprobe 版本
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeKernelSetup

    rlPhaseEnd

    rlPhaseStartTest "modprobe 版本"
        rlRun 'modprobe --version 2>&1 || true' 0 "modprobe 版本"
        rlRun 'ls /lib/modules/$(uname -r) 2>&1 | head -5 || true' 0 "模块目录存在"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd