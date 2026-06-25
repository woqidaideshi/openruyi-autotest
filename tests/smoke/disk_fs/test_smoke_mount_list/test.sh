#!/bin/bash
# Smoke test: disk_fs - mount 挂载列表
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeDiskFsSetup

    rlPhaseEnd

    rlPhaseStartTest "mount 挂载列表"
        rlRun 'mount | head -5' 0 "mount 挂载列表"
        rlRun 'mount | grep " / "' 0 "mount 根分区挂载"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd