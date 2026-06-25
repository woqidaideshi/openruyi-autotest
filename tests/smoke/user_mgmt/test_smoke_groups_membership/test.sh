#!/bin/bash
# Smoke test: user_mgmt - groups 当前用户组
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeUserMgmtSetup

    rlPhaseEnd

    rlPhaseStartTest "groups 当前用户组"
        rlRun 'groups' 0 "groups 当前用户组"
        rlRun 'groups root' 0 "groups root用户组"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd