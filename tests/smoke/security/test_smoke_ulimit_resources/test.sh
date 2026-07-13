#!/bin/bash
# Smoke test: security - ulimit -n filedescriptor limit
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeSecuritySetup

 rlPhaseEnd

 rlPhaseStartTest "ulimit -n filedescriptor limit"
 rlRun 'ulimit -n' 0 "ulimit -n filedescriptor limit"
 rlRun 'ulimit -u' 0 "ulimit -u userprocesscount"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd