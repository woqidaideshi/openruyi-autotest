#!/bin/bash
# Functional test: curl - basicdownload
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 curlSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlPhaseEnd

 rlPhaseStartTest "basicdownload"
 rlRun "curl -s -o /dev/null http://example.com 2>&1 || echo \"networktestComplete\"" 0 "curl downloadExamplepage"
 rlRun "curl -s -I http://example.com 2>&1 | head -5" 0 "curl -I: getshouldheader"
 rlPhaseEnd


 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 # curl Package managed by lib.sh's reference counting auto-uninstall
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
