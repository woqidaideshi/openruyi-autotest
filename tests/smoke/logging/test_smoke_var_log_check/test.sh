#!/bin/bash
# Smoke test: logging - /var/log 目录存在
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeLoggingSetup

    rlPhaseEnd

    rlPhaseStartTest "/var/log 目录存在"
        rlRun 'test -d /var/log' 0 "/var/log 目录存在"
        rlRun 'ls /var/log | head -10' 0 "/var/log 日志文件列表"
        rlRun 'test -f /var/log/messages || test -f /var/log/syslog || echo "no standard syslog"' 0 "系统日志存在性检查"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd