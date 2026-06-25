#!/bin/bash
# Smoke test: package_mgmt - /etc/os-release 存在
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokePackageMgmtSetup

    rlPhaseEnd

    rlPhaseStartTest "/etc/os-release 存在"
        rlRun 'cat /etc/os-release' 0 "/etc/os-release 存在"
        rlRun 'grep openRuyi /etc/os-release' 0 "openRuyi 发行版确认"
        rlRun 'rpm -q openruyi-release' 0 "openruyi-release 包存在"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd