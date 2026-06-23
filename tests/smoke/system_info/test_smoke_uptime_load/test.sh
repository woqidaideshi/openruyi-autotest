#!/bin/bash
# Smoke test: system_info - /proc/uptime 运行时间
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeSystemInfoSetup

    rlPhaseEnd

    rlPhaseStartTest "/proc/uptime 运行时间"
        rlRun 'cat /proc/uptime' 0 "/proc/uptime 运行时间"
        rlRun 'cat /proc/loadavg' 0 "/proc/loadavg 系统负载"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd