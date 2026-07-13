#!/bin/bash
# Smoke test: archive - gzip compress
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeArchiveSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlRun "dd if=/dev/zero of=big.txt bs=1k count=10 2>/dev/null" 0 "Create test data"

 rlPhaseEnd

 rlPhaseStartTest "gzip compress"
 rlRun 'gzip big.txt' 0 "gzip compress"
 rlRun 'test -f big.txt.gz' 0 "compressfile exists"
 rlRun 'gunzip big.txt.gz' 0 "gunzip decompress"
 rlRun 'test -f big.txt' 0 "decompressfile"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd