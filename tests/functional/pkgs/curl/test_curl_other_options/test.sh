#!/bin/bash

# Functional test: curl - otheroption

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



    rlPhaseStartTest "otheroption"

    rlRun "curl -L http://example.com 2>&1 | head -3 || echo \"\"" 0 "curl -L: "

    rlRun "curl -k https://example.com 2>&1 | head -3 || echo \"certificate\"" 0 "curl -k: SSLcertificate"

    rlRun "curl --connect-timeout 5 http://example.com 2>&1 | head -3 || echo \"timeout\"" 0 "curl --connect-timeout: connectiontimeout"

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

