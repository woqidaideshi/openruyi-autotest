#!/bin/bash

# Smoke test: filesystem - cat read file

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 smokeFSSetup

 TmpDir=$(mktemp -d)

 rlRun "cd $TmpDir" 0 "Enter temporary test directory"

 rlRun "echo 'line1' > f.txt" 0 "Create test file"

 rlPhaseEnd



 rlPhaseStartTest "cat readandfile"

 rlRun "cat f.txt" 0 "cat readfile"

 rlRun "cat /etc/os-release | head -3" 0 "cat systemfile"

 rlPhaseEnd



 rlPhaseStartCleanup "Clean up test environment"

 rlRun "cd /" 0 "Leave test directory"

 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then

 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"

 fi

 rlPhaseEnd



 rlJournalPrintText

rlJournalEnd