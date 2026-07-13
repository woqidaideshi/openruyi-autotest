#!/bin/bash
# Functional test: coreutils - Path-operations--basename--dirname--pwd
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 coreutilsSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlPhaseEnd

 rlPhaseStartTest "Path-operations--basename--dirname--pwd"
 rlRun "test \"$(basename /usr/bin/grep)\" = \"grep\"" 0 "basename extract filename"
 rlRun "test \"$(basename /path/to/file.txt .txt)\" = \"file\"" 0 "basename strip suffix"
 rlRun "test \"$(dirname /usr/bin/grep)\" = \"/usr/bin\"" 0 "dirname extract directory"
 rlRun "test \"$(dirname /path/to/file.txt)\" = \"/path/to\"" 0 "dirname path extraction"
 rlRun "pwd" 0 "pwd print working directory"
 rlPhaseEnd


 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 # coreutils Package managed by lib.sh 's reference counting auto-uninstall
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
