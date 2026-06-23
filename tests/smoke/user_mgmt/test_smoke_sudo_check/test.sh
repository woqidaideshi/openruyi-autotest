#!/bin/bash
# Smoke test: user_mgmt - sudo 命令存在
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeUserMgmtSetup

    rlPhaseEnd

    rlPhaseStartTest "sudo 命令存在"
        rlRun 'which sudo' 0 "sudo 命令存在"
        rlRun 'sudo -V 2>&1 | head -1' 0 "sudo 版本"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd