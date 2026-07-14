#!/bin/bash

# Security test: openscap - info

# OpenSCAP: verifydatafilehas

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname $0)/../../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment Setup"

 openscapSetup

 TmpDir=$(mktemp -d)

 rlRun "cd $TmpDir" 0 "Enter tmp dir"

 rlPhaseEnd



 rlPhaseStartTest "openscap - info"

 rlRun "_openscapInfo" 0 "Run verifydatafilehas"

 rlPhaseEnd



 rlPhaseStartCleanup "Cleanup"

 rlRun "cd /" 0 "Leave tmp dir"

 [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Clean tmp"

 rlPhaseEnd



 rlJournalPrintText

rlJournalEnd

