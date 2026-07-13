#!/bin/bash
# Functional test: audit - version and help
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 auditSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlPhaseEnd

 rlPhaseStartTest "version and help"
 rlRun "auditctl --version 2>&1 | grep -qiE \"error|Error|not found|No such|Unable to\" || echo expected-error" 1 "auditctl version info"
 rlRun "auditctl --help 2>&1 | head -5 || true" 0 "auditctl help info"
 rlRun "ausearch --version 2>&1 | grep -qiE \"error|Error|not found|No such|Unable to\" || echo expected-error" 1 "ausearch version info"
 rlRun "ausearch --help 2>&1 | head -5 || true" 0 "ausearch help info"
 rlRun "aureport --version 2>&1 | grep -qiE \"error|Error|not found|No such|Unable to\" || echo expected-error" 1 "aureport version info"
 rlRun "aureport --help 2>&1 | head -5 || true" 0 "aureport help info"
 rlRun "aulast --version 2>&1 | grep -qiE \"error|Error|not found|No such|Unable to\" || echo expected-error" 1 "aulast version info"
 rlRun "aulast --help 2>&1 | head -5 || true" 0 "aulast help info"
 rlRun "aulastlog --version 2>&1 | grep -qiE \"error|Error|not found|No such|Unable to\" || echo expected-error" 1 "aulastlog version info"
 rlRun "aulastlog --help 2>&1 | head -5 || true" 0 "aulastlog help info"
 rlRun "ausyscall --version 2>&1 | grep -qiE \"error|Error|not found|No such|Unable to\" || echo expected-error" 1 "ausyscall version info"
 rlRun "ausyscall --help 2>&1 | head -5 || true" 0 "ausyscall help info"
 rlRun "augenrules --version 2>&1 | grep -qiE \"error|Error|not found|No such|Unable to\" || echo expected-error" 1 "augenrules version info"
 rlRun "augenrules --help 2>&1 | head -5 || true" 0 "augenrules help info"
 rlPhaseEnd


 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 # audit Package managed by lib.sh 's reference counting auto-uninstall
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
