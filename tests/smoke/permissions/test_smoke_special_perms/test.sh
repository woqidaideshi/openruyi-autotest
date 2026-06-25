#!/bin/bash
# Smoke test: permissions - passwd 权限检查
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokePermissionsSetup

    rlPhaseEnd

    rlPhaseStartTest "passwd 权限检查"
        rlRun 'ls -l /usr/bin/passwd' 0 "passwd 权限检查"
        rlRun 'ls -l /usr/bin/sudo' 0 "sudo 权限检查"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd