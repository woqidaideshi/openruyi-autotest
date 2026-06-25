#!/bin/bash
# Smoke test: dev_tools - python3 可用
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeDevToolsSetup

    rlPhaseEnd

    rlPhaseStartTest "python3 可用"
        rlRun 'which python3' 0 "python3 可用"
        rlRun 'python3 --version' 0 "python3 版本"
        rlRun 'python3 -c "print(1+1)"' 0 "python3 基本运算"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd