#!/bin/bash

# Smoke test: filesystem - touch create file

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 smokeFSSetup

 TmpDir=$(mktemp -d)

 rlRun "cd $TmpDir" 0 "Enter temporary test directory"

 rlPhaseEnd



 rlPhaseStartTest "touch createfile"

 rlRun "touch empty.txt" 0 "touch createfile"

 rlRun "test -f empty.txt" 0 "file exists"

 rlRun "test ! -s empty.txt" 0 "filesizeis0"

 rlRun "touch -t 202401010000 ref.txt" 0 "touch settimestamp"

 rlPhaseEnd



 rlPhaseStartCleanup "Clean up test environment"

 rlRun "cd /" 0 "Leave test directory"

 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then

 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"

 fi

 rlPhaseEnd



 rlJournalPrintText

rlJournalEnd