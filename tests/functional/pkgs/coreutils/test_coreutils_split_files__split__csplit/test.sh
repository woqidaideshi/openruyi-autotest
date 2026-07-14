#!/bin/bash
# Functional test: coreutils - Split-files--split--csplit
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

    rlPhaseStartTest "Split-files--split--csplit"
    rlRun "split -l 5 lines.txt split_" 0 "split by lines"
    rlRun "test $(ls split_* | wc -l) -ge 4" 0 "split: multiple output files"
    rlRun "csplit fruits.txt /apple/ {1} 2>&1 | grep -qiE \"error|Error|not found|No such|Unable to\" || echo expected-error" 1 "csplit split by pattern"
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
