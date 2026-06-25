#!/bin/bash
# Smoke test: package_mgmt - rpm 脚本内容
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokePackageMgmtSetup

    rlPhaseEnd

    rlPhaseStartTest "rpm 脚本内容"
        rlRun 'rpm -q --scripts bash 2>&1 | head -5' 0 "rpm 脚本内容"
        rlRun 'rpm -ql bash | head -5' 0 "rpm -ql 文件列表"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd