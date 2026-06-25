#!/bin/bash
# Smoke test: user_mgmt - whoami 当前用户
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeUserMgmtSetup

    rlPhaseEnd

    rlPhaseStartTest "whoami 当前用户"
        rlRun 'whoami' 0 "whoami 当前用户"
        rlRun 'id' 0 "id 用户和组信息"
        rlRun 'id -u' 0 "id -u UID"
        rlRun 'id -g' 0 "id -g GID"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd