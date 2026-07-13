#!/bin/bash
# Functional test: coreutils - Checksums--cksum--md5sum--sha1sum--sha224sum--sha3
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 coreutilsSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlPhaseEnd

 rlPhaseStartTest "Checksums--cksum--md5sum--sha1sum--sha224sum--sha3"
 rlRun "cksum file1.txt" 0 "cksum CRC checksum"
 rlRun "md5sum file1.txt" 0 "md5sum compute"
 rlRun "md5sum file1.txt > md5_check.txt" 0 "md5sum save"
 rlRun "md5sum -c md5_check.txt" 0 "md5sum -c verify"
 rlRun "sha1sum file1.txt" 0 "sha1sum compute"
 rlRun "sha1sum file1.txt > sha1_check.txt" 0 "sha1sum save"
 rlRun "sha1sum -c sha1_check.txt" 0 "sha1sum -c verify"
 rlRun "sha224sum file1.txt" 0 "sha224sum compute"
 rlRun "sha256sum file1.txt" 0 "sha256sum compute"
 rlRun "sha256sum file1.txt > sha256_check.txt" 0 "sha256sum save"
 rlRun "sha256sum -c sha256_check.txt" 0 "sha256sum -c verify"
 rlRun "sha384sum file1.txt" 0 "sha384sum compute"
 rlRun "sha512sum file1.txt" 0 "sha512sum compute"
 rlRun "b2sum file1.txt" 0 "b2sum BLAKE2 checksum"
 rlRun "sum file1.txt" 0 "sum BSD checksum"
 rlPhaseEnd


 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 # coreutils Package managed by lib.sh 's reference counting auto-uninstall
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
