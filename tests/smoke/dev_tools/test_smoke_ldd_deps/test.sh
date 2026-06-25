#!/bin/bash
# Smoke test: dev_tools - ldd 查看链接
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeDevToolsSetup

    rlPhaseEnd

    rlPhaseStartTest "ldd 查看链接"
        rlRun 'ldd /bin/sh' 0 "ldd 查看链接"
        rlRun 'ldd /bin/ls' 0 "ldd ls 依赖"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd