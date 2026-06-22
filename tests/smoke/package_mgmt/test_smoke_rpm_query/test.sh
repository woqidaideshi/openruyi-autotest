#!/bin/bash
# Smoke test: package_mgmt - rpm 版本
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokePackageMgmtSetup

    rlPhaseEnd

    rlPhaseStartTest "rpm 版本"
        rlRun 'rpm --version' 0 "rpm 版本"
        rlRun 'rpm -q coreutils' 0 "rpm -q 查询包"
        rlRun 'rpm -qa | head -5' 0 "rpm -qa 列出所有包"
        rlRun 'rpm -qi coreutils | head -5' 0 "rpm -qi 包信息"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd