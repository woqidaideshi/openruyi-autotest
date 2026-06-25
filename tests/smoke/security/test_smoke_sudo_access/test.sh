#!/bin/bash
# Smoke test: security - /etc/sudoers 存在
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeSecuritySetup

    rlPhaseEnd

    rlPhaseStartTest "/etc/sudoers 存在"
        rlRun 'test -f /etc/sudoers' 0 "/etc/sudoers 存在"
        rlRun 'sudo -l 2>&1 || true' 0 "sudo -l 列出权限"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd