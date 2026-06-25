#!/bin/bash
# Smoke test: user_mgmt - /etc/passwd 文件存在
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeUserMgmtSetup

    rlPhaseEnd

    rlPhaseStartTest "/etc/passwd 文件存在"
        rlRun 'test -f /etc/passwd' 0 "/etc/passwd 文件存在"
        rlRun 'test -f /etc/shadow' 0 "/etc/shadow 文件存在"
        rlRun 'cat /etc/passwd | head -3' 0 "/etc/passwd 可读"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd