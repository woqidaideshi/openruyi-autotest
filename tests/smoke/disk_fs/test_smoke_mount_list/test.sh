#!/bin/bash

# Smoke test: disk_fs - mount mountlist

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 smokeDiskFsSetup



 rlPhaseEnd



 rlPhaseStartTest "mount mountlist"

 rlRun 'mount | head -5' 0 "mount mountlist"

 rlRun 'mount | grep " / "' 0 "mount rootpartitionmount"

 rlPhaseEnd



 rlPhaseStartCleanup "Clean up test environment"



 rlPhaseEnd



 rlJournalPrintText

rlJournalEnd