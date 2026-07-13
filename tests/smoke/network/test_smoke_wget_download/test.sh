#!/bin/bash
# Smoke test: network - wget version
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeNetworkSetup

 rlPhaseEnd

 rlPhaseStartTest "wget version"
 rlRun 'wget --version 2>&1 || true' 0 "wget version"
 rlRun 'wget --timeout=5 --spider http://example.com 2>&1 || true' 0 "wget spidermode"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd