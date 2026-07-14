#!/bin/bash
# Smoke test: shell_basics - pipe | connectioncommand
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    smokeShellBasicsSetup
    TmpDir=$(mktemp -d)
    rlRun "cd $TmpDir" 0 "Enter temporary test directory"
    rlRun "echo "data" > out.txt" 0 "Create test data"
    rlRun "echo "more" >> out.txt" 0 "Create test data"

    rlPhaseEnd

    rlPhaseStartTest "pipe | connectioncommand"
    rlRun 'cat out.txt | wc -l' 0 "pipe | connectioncommand"
    rlRun 'wc -l < out.txt' 0 " < input"
    rlRun 'grep data out.txt > /dev/null 2>&1' 0 " /dev/null"
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"
    rlRun "cd /" 0 "Leave test directory"
    if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
    rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
    fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd