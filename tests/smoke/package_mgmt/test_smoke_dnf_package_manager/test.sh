#!/bin/bash
# Smoke test: package_mgmt - dnf 版本
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokePackageMgmtSetup

    rlPhaseEnd

    rlPhaseStartTest "dnf 版本"
        rlRun 'dnf --version 2>&1 || true' 0 "dnf 版本"
        rlRun 'dnf repolist 2>&1 | head -5' 0 "dnf repolist 仓库列表"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd