#!/bin/bash
# Smoke test: archive - xz compress
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    smokeArchiveSetup
    TmpDir=$(mktemp -d)
    rlRun "cd $TmpDir" 0 "Enter temporary test directory"
    rlRun "dd if=/dev/zero of=data bs=1k count=10 2>/dev/null" 0 "Create test data"

    rlPhaseEnd

    rlPhaseStartTest "xz compress"
    rlRun 'xz data' 0 "xz compress"
    rlRun 'test -f data.xz' 0 "xz file exists"
    rlRun 'unxz data.xz' 0 "unxz decompress"
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"
    rlRun "cd /" 0 "Leave test directory"
    if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
    rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
    fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd