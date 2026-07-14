#!/bin/bash

# Security test: openscap - generate_fix

# OpenSCAP: Generatescript

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname $0)/../../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment Setup"

    openscapSetup

    TmpDir=$(mktemp -d)

    rlRun "cd $TmpDir" 0 "Enter tmp dir"

    rlPhaseEnd



    rlPhaseStartTest "openscap - generate_fix"

    rlRun "_openscapGenerateFix" 0 "Run Generatescript"

    rlPhaseEnd



    rlPhaseStartCleanup "Cleanup"

    rlRun "cd /" 0 "Leave tmp dir"

    [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Clean tmp"

    rlPhaseEnd



    rlJournalPrintText

rlJournalEnd

