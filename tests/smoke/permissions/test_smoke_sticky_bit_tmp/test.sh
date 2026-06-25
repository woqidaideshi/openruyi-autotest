#!/bin/bash
# Smoke test: permissions - /tmp 目录存在
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokePermissionsSetup

    rlPhaseEnd

    rlPhaseStartTest "/tmp 目录存在"
        rlRun 'test -d /tmp' 0 "/tmp 目录存在"
        rlRun 'ls -ld /tmp' 0 "ls -ld /tmp 权限"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd