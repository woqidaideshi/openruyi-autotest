#!/bin/bash
# Smoke test: disk_fs - /proc/partitions partitionlist
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeDiskFsSetup

 rlPhaseEnd

 rlPhaseStartTest "/proc/partitions partitionlist"
 rlRun 'cat /proc/partitions' 0 "/proc/partitions partitionlist"
 rlRun 'cat /proc/filesystems | head -5' 0 "/proc/filesystems supportsfilesystem"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd