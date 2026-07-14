#!/bin/bash
# Functional test: coreutils - Encoding--base32--base64--basenc
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

    rlPhaseStartTest "Encoding--base32--base64--basenc"
    rlRun "echo \"hello\" | base32" 0 "base32 encode"
    rlRun "echo \"hello\" | base32 | base32 -d" 0 "base32 -d decode"
    rlRun "echo \"hello\" | base64" 0 "base64 encode"
    rlRun "echo \"hello\" | base64 | base64 -d" 0 "base64 -d decode"
    rlRun "echo \"hello\" | basenc --base64" 0 "basenc --base64 encode"
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
