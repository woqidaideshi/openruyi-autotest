#!/bin/bash
# Smoke test: disk_fs - /etc/fstab 存在
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeDiskFsSetup

    rlPhaseEnd

    rlPhaseStartTest "/etc/fstab 存在"
        rlRun 'test -f /etc/fstab' 0 "/etc/fstab 存在"
        rlRun 'cat /etc/fstab | head -5' 0 "/etc/fstab 可读"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd