#!/bin/bash
# Smoke test: filesystem - file type detect
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeFSSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlRun "echo 'text' > t.txt" 0 "Create test file"
 rlPhaseEnd

 rlPhaseStartTest "file detectfiletype"
 rlRun "file t.txt | grep -i text" 0 "file this file"
 rlRun "file /bin/sh | grep -i elf" 0 "file ELF "
 rlRun "file /" 0 "file directory"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd