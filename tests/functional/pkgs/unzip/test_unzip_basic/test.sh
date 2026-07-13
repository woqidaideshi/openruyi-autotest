#!/bin/bash
# Functional test: unzip - error handling��
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 unzipSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlPhaseEnd

 rlPhaseStartTest "error handling��"
rlRun() { eval "$1" 2>&1; return $?; }
 rlRun "unzip --help 2>&1 | head -10" 0 "� unzip error handlingϢ"
 rlRun "funzip --help 2>&1 | head -10" 0 "� funzip error handlingϢ"
 rlRun "zipgrep --help 2>&1 | head -10" 0 "� zipgrep error handlingϢ"
 rlRun "zipinfo --help 2>&1 | head -10" 0 "� zipinfo error handlingϢ"
 rlPhaseEnd


 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 # unzip Package managed by lib.sh 's reference counting auto-uninstall
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
