#!/bin/bash
# Smoke test: system_info - hostname 显示主机名
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeSystemInfoSetup

    rlPhaseEnd

    rlPhaseStartTest "hostname 显示主机名"
        rlRun 'hostname' 0 "hostname 显示主机名"
        rlRun 'cat /etc/hostname' 0 "hostname 文件可读"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd