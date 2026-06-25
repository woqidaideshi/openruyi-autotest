#!/bin/bash
# Smoke test: kernel - 内核版本
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeKernelSetup

    rlPhaseEnd

    rlPhaseStartTest "内核版本"
        rlRun 'uname -r' 0 "内核版本"
        rlRun 'cat /proc/cmdline' 0 "/proc/cmdline 启动参数"
        rlRun 'cat /proc/version' 0 "/proc/version 内核编译信息"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd