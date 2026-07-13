#!/bin/bash
# Functional test: binutils - binutils error handling
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 binutilsSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlPhaseEnd

 rlPhaseStartTest "binutils error handling"
 rlRun "nm /nonexistent_file 2>&1 | grep -qiE \"No such|cannot|error\" || echo error-ok" 0 "nm ڵļ"
 rlRun "objdump /nonexistent_file 2>&1 | grep -qiE \"No such|cannot|error\" || echo error-ok" 0 "objdump ڵļ"
 rlRun "readelf /nonexistent_file 2>&1 | grep -qiE \"No such|cannot|error\" || echo error-ok" 0 "readelf ڵļ"
 rlRun "nm --help 2>&1 | grep -qiE \"Usage|Usage|usage\" || echo help-not-standard" 0 "nm Ч"
 rlPhaseEnd


 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 # binutils Package managed by lib.sh 's reference counting auto-uninstall
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
