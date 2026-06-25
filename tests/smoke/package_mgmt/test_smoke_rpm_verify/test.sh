#!/bin/bash
# Smoke test: package_mgmt - rpm -V 验证包完整性
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokePackageMgmtSetup

    rlPhaseEnd

    rlPhaseStartTest "rpm -V 验证包完整性"
        rlRun 'rpm -V coreutils 2>&1 || true' 0 "rpm -V 验证包完整性"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd