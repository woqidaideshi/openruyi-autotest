#!/bin/bash
# Functional test: e2fsprogs - e2fsprogs error handling��
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 e2fsprogsSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlPhaseEnd

 rlPhaseStartTest "e2fsprogs error handling��"
 rlRun "TmpDir=$(mktemp -d)" 0 "error handlingʱĿ¼"
 rlRun "cd $TmpDir" 0 "error handlingdirectory"
 rlRun "dd if=/dev/zero of=test.img bs=1M count=10" 0 "error handling�Ծ���"
 rlRun "mke2fs -F test.img" 0 "���� ext2 �ļ�ϵͳ"
 rlRun "dumpe2fs test.img 2>&1 | head -10" 0 "��ļ�ϵͳ��Ϣ"
 rlPhaseEnd


 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 # e2fsprogs Package managed by lib.sh 's reference counting auto-uninstall
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
