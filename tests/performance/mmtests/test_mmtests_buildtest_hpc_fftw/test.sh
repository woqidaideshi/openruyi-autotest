#!/bin/bash
# Functional test: kernel - mmtests - buildtest_hpc_fftw
# MMTests: run-mmtests.sh --config configs/config-buildtest-hpc-fftw
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 mmtestsSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlPhaseEnd

 rlPhaseStartTest "MMTests - buildtest_hpc_fftw"
 rlRun "_mmtestsRunCase config-buildtest-hpc-fftw" 0 "Execute MMTests config-buildtest-hpc-fftw"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Cleanup"
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd