#!/bin/bash
# Smoke test: shell_basics - for 循环正常
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeShellBasicsSetup
        rlRun "for i in 1 2 3; do echo $i; done | grep -q 2" 0 "准备环境"
        rlRun "n=0; while [ $n -lt 3 ]; do n=$((n+1)); done; test $n -eq 3" 0 "准备环境"

    rlPhaseEnd

    rlPhaseStartTest "for 循环正常"
        rlRun 'echo ok' 0 "for 循环正常"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd