#!/bin/bash
# Smoke test: system_info - /proc/cpuinfo CPU 信息
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeSystemInfoSetup

    rlPhaseEnd

    rlPhaseStartTest "/proc/cpuinfo CPU 信息"
        rlRun 'cat /proc/cpuinfo | head -5' 0 "/proc/cpuinfo CPU 信息"
        rlRun 'cat /proc/meminfo | head -5' 0 "/proc/meminfo 内存信息"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd