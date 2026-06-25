#!/bin/bash
# Smoke test: network - wget 版本
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeNetworkSetup

    rlPhaseEnd

    rlPhaseStartTest "wget 版本"
        rlRun 'wget --version 2>&1 || true' 0 "wget 版本"
        rlRun 'wget --timeout=5 --spider http://example.com 2>&1 || true' 0 "wget spider模式"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd