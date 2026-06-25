#!/bin/bash
# Smoke test: disk_fs - /proc/partitions 分区列表
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeDiskFsSetup

    rlPhaseEnd

    rlPhaseStartTest "/proc/partitions 分区列表"
        rlRun 'cat /proc/partitions' 0 "/proc/partitions 分区列表"
        rlRun 'cat /proc/filesystems | head -5' 0 "/proc/filesystems 支持的文件系统"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd