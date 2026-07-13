#!/bin/bash
# Smoke test: dev_tools - ldd viewlink
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeDevToolsSetup

 rlPhaseEnd

 rlPhaseStartTest "ldd viewlink"
 rlRun 'ldd /bin/sh' 0 "ldd viewlink"
 rlRun 'ldd /bin/ls' 0 "ldd ls Dependencies"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd