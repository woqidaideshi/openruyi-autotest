#!/bin/bash
# Functional test: python - commandlinesoption
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 pythonSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlPhaseEnd

 rlPhaseStartTest "commandlinesoption"
 rlRun "python3 -h 2>&1 | head -5" 0 "python3 -h: "
 rlRun "python3 -V" 0 "python3 -V: version"
 rlRun "python3 -c \"import os; print(os.name)\"" 0 "python3: osmodule"
 rlPhaseEnd


 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 # python Package managed by lib.sh's reference counting auto-uninstall
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
