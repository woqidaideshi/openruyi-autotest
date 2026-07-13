#!/bin/bash
# Functional test: tar - Compression-formats
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 tarSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlPhaseEnd

 rlPhaseStartTest "Compression-formats"
 rlRun "tar -czf $TmpDir/test.tgz -C $TmpDir testdir" 0 "tar gzip compress"
 rlRun "tar -cJf $TmpDir/test.xz -C $TmpDir testdir" 0 "tar xz compress"
 rlRun "test -f $TmpDir/test.tgz" 0 "verify tgz file"
 rlRun "test -f $TmpDir/test.xz" 0 "verify xz file"
 rlPhaseEnd


 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 # tar Package managed by lib.sh 's reference counting auto-uninstall
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
