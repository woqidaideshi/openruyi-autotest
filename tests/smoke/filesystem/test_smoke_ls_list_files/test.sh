#!/bin/bash

# Smoke test: filesystem - ls list files and directories

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 smokeFSSetup

 TmpDir=$(mktemp -d)

 rlRun "cd $TmpDir" 0 "Enter temporary test directory"

 rlRun "echo 'hello' > a.txt" 0 "Create test file"

 rlRun "mkdir subdir" 0 "Create test directory"

 rlPhaseEnd



 rlPhaseStartTest "ls listexportfileanddirectory"

 rlRun "ls" 0 "ls listexportcurrentdirectory"

 rlRun "ls -la" 0 "ls -la listexport"

 rlRun "ls -l a.txt" 0 "ls specifyfile"

 rlRun "ls -d subdir" 0 "ls -d listexportdirectory"

 rlRun "ls /tmp" 0 "ls listexportsystemdirectory"

 rlPhaseEnd



 rlPhaseStartCleanup "Clean up test environment"

 rlRun "cd /" 0 "Leave test directory"

 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then

 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"

 fi

 rlPhaseEnd



 rlJournalPrintText

rlJournalEnd