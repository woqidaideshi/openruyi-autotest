#!/bin/bash
# Smoke test: scripting - sleep 1秒
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeScriptingSetup

    rlPhaseEnd

    rlPhaseStartTest "sleep 1秒"
        rlRun 'sleep 1' 0 "sleep 1秒"
        rlRun 'timeout 1 sleep 0.5' 0 "timeout 命令"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd