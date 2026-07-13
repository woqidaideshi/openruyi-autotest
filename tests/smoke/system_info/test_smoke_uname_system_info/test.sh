#!/bin/bash
# Smoke test: system_info - uname kernelname
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeSystemInfoSetup

 rlPhaseEnd

 rlPhaseStartTest "uname kernelname"
 rlRun 'uname' 0 "uname kernelname"
 rlRun 'uname -a' 0 "uname -a allinfo"
 rlRun 'uname -r' 0 "uname -r kernelversion"
 rlRun 'uname -m' 0 "uname -m "
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd