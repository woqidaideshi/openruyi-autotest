#!/bin/bash
# Smoke test: process - pidof 查找systemd
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeProcessSetup

    rlPhaseEnd

    rlPhaseStartTest "pidof 查找systemd"
        rlRun 'pidof systemd' 0 "pidof 查找systemd"
        rlRun 'pgrep -x systemd' 0 "pgrep 查找进程"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd