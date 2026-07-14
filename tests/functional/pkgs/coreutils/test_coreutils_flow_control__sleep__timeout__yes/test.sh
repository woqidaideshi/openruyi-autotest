#!/bin/bash
# Functional test: coreutils - Flow-control--sleep--timeout--yes
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

    rlPhaseStartTest "Flow-control--sleep--timeout--yes"
    rlRun "sleep 0.1" 0 "sleep delay"
    rlRun "timeout 2 sleep 0.1" 0 "timeout: command finishes in time"
    rlRun "timeout 2 sleep 0.1 && echo ok" 0 "timeout: successful completion"
    rlRun "timeout 0.1 sleep 5" 124 "timeout: kills slow command"
    rlRun "yes | head -5" 0 "yes repeated output"
    rlRun "yes hello | head -3" 0 "yes custom string"
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
