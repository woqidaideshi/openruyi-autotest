#!/bin/bash
# Functional test: diffutils - error handling
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 diffutilsSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlPhaseEnd

 rlPhaseStartTest "error handling"
 rlRun "cmp --invalid-flag-xyz 2>&1 | grep -qiE \"error|Error|not found|No such|Unable to\" || echo expected-error" 1 "���� cmp ��Чerror handling����"
 rlRun "diff --invalid-flag-xyz 2>&1 | grep -qiE \"error|Error|not found|No such|Unable to\" || echo expected-error" 1 "���� diff ��Чerror handling����"
 rlRun "diff3 --invalid-flag-xyz 2>&1 | grep -qiE \"error|Error|not found|No such|Unable to\" || echo expected-error" 1 "���� diff3 ��Чerror handling����"
 rlRun "sdiff --invalid-flag-xyz 2>&1 | grep -qiE \"error|Error|not found|No such|Unable to\" || echo expected-error" 1 "���� sdiff ��Чerror handling����"
 rlPhaseEnd


 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 # diffutils Package managed by lib.sh 's reference counting auto-uninstall
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
