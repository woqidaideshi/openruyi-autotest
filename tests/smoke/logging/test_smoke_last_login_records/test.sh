#!/bin/bash
# Smoke test: logging - last 最近登录
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeLoggingSetup

    rlPhaseEnd

    rlPhaseStartTest "last 最近登录"
        rlRun 'last -n 5 2>&1 || true' 0 "last 最近登录"
        rlRun 'test -f /var/log/wtmp' 0 "/var/log/wtmp 登录记录"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd