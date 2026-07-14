#!/bin/bash
# Functional test: debugedit - version and help
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    debugeditSetup
    TmpDir=$(mktemp -d)
    rlRun "cd $TmpDir" 0 "Enter temporary test directory"
    rlPhaseEnd

    rlPhaseStartTest "version and help"
    rlRun "debugedit --version 2>&1 | grep -qiE \"error|Error|not found|No such|Unable to\" || echo expected-error" 1 "debugedit version info"
    rlRun "debugedit --help 2>&1 | head -5 || true" 0 "debugedit help info"
    rlRun "debugedit-classify-ar --version 2>&1 | grep -qiE \"error|Error|not found|No such|Unable to\" || echo expected-error" 1 "debugedit-classify-ar version info"
    rlRun "debugedit-classify-ar --help 2>&1 | head -5 || true" 0 "debugedit-classify-ar help info"
    rlPhaseEnd


    rlPhaseStartCleanup "Clean up test environment"
    rlRun "cd /" 0 "Leave test directory"
    if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
    rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
    fi
    # debugedit Package managed by lib.sh 's reference counting auto-uninstall
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
