#!/bin/bash
# Smoke test: filesystem - stat file info
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeFSSetup
    rlPhaseEnd

    rlPhaseStartTest "stat 查看文件信息"
        rlRun "stat /etc/os-release" 0 "stat 查看文件"
        rlRun "stat -c '%s' /etc/os-release" 0 "stat 格式化输出大小"
        rlRun "stat /" 0 "stat 查看目录"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd