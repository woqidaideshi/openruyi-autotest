#!/bin/bash
# Smoke test: package_mgmt - rpm script content
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokePackageMgmtSetup

 rlPhaseEnd

 rlPhaseStartTest "rpm script content"
 rlRun 'rpm -q --scripts bash 2>&1 | head -5' 0 "rpm script content"
 rlRun 'rpm -ql bash | head -5' 0 "rpm -ql filelist"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd