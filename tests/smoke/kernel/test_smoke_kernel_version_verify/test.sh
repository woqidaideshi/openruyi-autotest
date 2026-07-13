#!/bin/bash
# Smoke test: kernel - kernelversion
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeKernelSetup

 rlPhaseEnd

 rlPhaseStartTest "kernelversion"
 rlRun 'uname -r' 0 "kernelversion"
 rlRun 'cat /proc/cmdline' 0 "/proc/cmdline parameter"
 rlRun 'cat /proc/version' 0 "/proc/version kernelcompileinfo"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd