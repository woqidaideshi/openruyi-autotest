#!/bin/bash
# Functional test: coreutils - Environment-and-time--env--printenv--date--printf
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

    rlPhaseStartTest "Environment-and-time--env--printenv--date--printf"
    rlRun "env" 0 "env show environment"
    rlRun "env PATH=/usr/bin echo test" 0 "env set variable for command"
    rlRun "printenv PATH" 0 "printenv show PATH"
    rlRun "date" 0 "date current date/time"
    rlRun "date +%Y-%m-%d" 0 "date custom format"
    rlRun "date -u" 0 "date -u UTC time"
    rlRun "printf \"%s %d\n\" hello 42" 0 "printf formatted output"
    rlRun "test \"$(printf \"%s\" one two)\" = \"onetwo\"" 0 "printf string output"
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
