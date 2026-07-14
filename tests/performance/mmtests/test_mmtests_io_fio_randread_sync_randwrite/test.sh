#!/bin/bash
# Functional test: kernel - mmtests - io_fio_randread_sync_randwrite
# MMTests: run-mmtests.sh --config configs/config-io-fio-randread-sync-randwrite
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    mmtestsSetup
    TmpDir=$(mktemp -d)
    rlRun "cd $TmpDir" 0 "Enter temporary test directory"
    rlPhaseEnd

    rlPhaseStartTest "MMTests - io_fio_randread_sync_randwrite"
    rlRun "_mmtestsRunCase config-io-fio-randread-sync-randwrite" 0 "Execute MMTests config-io-fio-randread-sync-randwrite"
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"
    rlRun "cd /" 0 "Leave test directory"
    [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Cleanup"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd