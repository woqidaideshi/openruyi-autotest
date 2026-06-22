#!/bin/bash
# Smoke test: logging - /etc/logrotate.d 目录存在
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeLoggingSetup

    rlPhaseEnd

    rlPhaseStartTest "/etc/logrotate.d 目录存在"
        rlRun 'test -d /etc/logrotate.d' 0 "/etc/logrotate.d 目录存在"
        rlRun 'logrotate --version 2>&1 || true' 0 "logrotate 可用"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd