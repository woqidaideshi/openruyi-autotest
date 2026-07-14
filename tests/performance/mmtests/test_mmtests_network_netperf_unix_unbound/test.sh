#!/bin/bash
# Functional test: kernel - mmtests - network_netperf_unix_unbound
# MMTests: run-mmtests.sh --config configs/config-network-netperf-unix-unbound
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    mmtestsSetup
    TmpDir=$(mktemp -d)
    rlRun "cd $TmpDir" 0 "Enter temporary test directory"
    rlPhaseEnd

    rlPhaseStartTest "MMTests - network_netperf_unix_unbound"
    rlRun "_mmtestsRunCase config-network-netperf-unix-unbound" 0 "Execute MMTests config-network-netperf-unix-unbound"
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"
    rlRun "cd /" 0 "Leave test directory"
    [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Cleanup"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd