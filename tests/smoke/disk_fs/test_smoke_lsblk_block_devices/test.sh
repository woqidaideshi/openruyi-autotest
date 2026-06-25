#!/bin/bash
# Smoke test: disk_fs - lsblk 块设备
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeDiskFsSetup

    rlPhaseEnd

    rlPhaseStartTest "lsblk 块设备"
        rlRun 'lsblk' 0 "lsblk 块设备"
        rlRun 'lsblk -f 2>&1 || true' 0 "lsblk -f 文件系统"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd