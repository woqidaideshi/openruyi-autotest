#!/bin/bash
# Smoke test: kernel - /proc/sys 目录存在
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeKernelSetup

    rlPhaseEnd

    rlPhaseStartTest "/proc/sys 目录存在"
        rlRun 'test -d /proc/sys' 0 "/proc/sys 目录存在"
        rlRun 'cat /proc/sys/kernel/hostname' 0 "/proc/sys 可读"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd