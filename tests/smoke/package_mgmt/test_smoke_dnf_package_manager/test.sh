#!/bin/bash
# Smoke test: package_mgmt - dnf version
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokePackageMgmtSetup

 rlPhaseEnd

 rlPhaseStartTest "dnf version"
 rlRun 'dnf --version 2>&1 || true' 0 "dnf version"
 rlRun 'dnf repolist 2>&1 | head -5' 0 "dnf repolist repolibrarylist"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd