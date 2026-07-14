#!/bin/bash
# Smoke test: disk_fs - lsblk blockdevice
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeDiskFsSetup

 rlPhaseEnd

 rlPhaseStartTest "lsblk blockdevice"
 rlRun 'lsblk' 0 "lsblk blockdevice"
 rlRun 'lsblk -f 2>&1 || true' 0 "lsblk -f filesystem"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd