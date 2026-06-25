#!/bin/bash
# Smoke test: user_mgmt - /etc/skel 骨架目录存在
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeUserMgmtSetup

    rlPhaseEnd

    rlPhaseStartTest "/etc/skel 骨架目录存在"
        rlRun 'test -d /etc/skel' 0 "/etc/skel 骨架目录存在"
        rlRun 'ls -la /home' 0 "ls /home 用户家目录"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd