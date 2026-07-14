#!/bin/bash
# Functional test: git - Reset-and-restore
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    gitSetup
    TmpDir=$(mktemp -d)
    rlRun "cd $TmpDir" 0 "Enter temporary test directory"
    rlPhaseEnd

    rlPhaseStartTest "Reset-and-restore"
    rlRun "git add temp.txt" 0 "git add: temp file"
    rlRun "git reset HEAD temp.txt" 0 "git reset: unstage"
    rlRun "git restore --staged temp.txt 2>&1 | grep -qiE \"error|Error|not found|No such|Unable to\" || echo expected-error" 1 "git restore --staged"
    rlRun "rm -f temp.txt" 0 "Cleanup temp"
    rlPhaseEnd


    rlPhaseStartCleanup "Clean up test environment"
    rlRun "cd /" 0 "Leave test directory"
    if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
    rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
    fi
    # git Package managed by lib.sh 's reference counting auto-uninstall
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
