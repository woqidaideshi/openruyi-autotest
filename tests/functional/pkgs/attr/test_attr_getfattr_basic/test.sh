#!/bin/bash
# Functional test: attr - getfattr error handling��
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 attrSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlPhaseEnd

 rlPhaseStartTest "getfattr error handling��"
 rlRun "TmpDir=$(mktemp -d)" 0 "error handlingdirectory"
 rlRun "cd $TmpDir" 0 "error handlingdirectory"
 rlRun "touch testfile" 0 "error handling���ļ�"
 rlRun "mkdir testdir" 0 "error handling��Ŀ¼"
 rlRun "getfattr -d testfile" 0 "��ļ���չ����"
 rlRun "setfattr -n user.test -v hello testfile" 0 "error handlingչ����"
 rlRun "getfattr -n user.test testfile" 0 "�ָ����չ����"
 rlRun "getfattr -d testfile" 0 "�error handlingչ����"
 rlPhaseEnd


 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 # attr Package managed by lib.sh's reference counting auto-uninstall
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
