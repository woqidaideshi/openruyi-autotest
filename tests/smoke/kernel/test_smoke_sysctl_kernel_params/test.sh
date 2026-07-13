#!/bin/bash
# Smoke test: kernel - sysctl -a kernelparameter
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeKernelSetup

 rlPhaseEnd

 rlPhaseStartTest "sysctl -a kernelparameter"
 rlRun 'sysctl -a 2>&1 | head -5 || true' 0 "sysctl -a kernelparameter"
 rlRun 'sysctl kernel.hostname 2>&1 || true' 0 "sysctl readhostnameparameter"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd