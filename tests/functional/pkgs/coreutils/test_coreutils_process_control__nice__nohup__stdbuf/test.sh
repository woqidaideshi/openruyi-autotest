#!/bin/bash
# Functional test: coreutils - Process-control--nice--nohup--stdbuf
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

    rlPhaseStartTest "Process-control--nice--nohup--stdbuf"
    rlRun "nice -n 10 true" 0 "nice adjust priority"
    rlRun "nohup true" 0 "nohup run command"
    rlRun "stdbuf -oL echo test 2>&1 | grep -qiE \"error|Error|not found|No such|Unable to\" || echo expected-error" 1 "stdbuf line buffered output"
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
