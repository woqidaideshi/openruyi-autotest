#!/bin/bash
# Smoke test: disk_fs - /etc/fstab exists
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeDiskFsSetup

 rlPhaseEnd

 rlPhaseStartTest "/etc/fstab exists"
 rlRun 'test -f /etc/fstab' 0 "/etc/fstab exists"
 rlRun 'cat /etc/fstab | head -5' 0 "/etc/fstab readable"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd