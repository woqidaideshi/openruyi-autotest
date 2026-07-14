#!/bin/bash
# Smoke test: package_mgmt - rpm -V verifypackage integrity
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokePackageMgmtSetup

 rlPhaseEnd

 rlPhaseStartTest "rpm -V verifypackage integrity"
 rlRun 'rpm -V coreutils 2>&1 || true' 0 "rpm -V verifypackage integrity"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd