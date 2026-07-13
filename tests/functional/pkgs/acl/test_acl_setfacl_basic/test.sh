#!/bin/bash
# Functional test: acl - setfacl basic
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 aclSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlRun "touch testfile" 0 "Create test file"
 rlRun "mkdir testdir" 0 "Create test directory"
 rlPhaseEnd

 rlPhaseStartTest "setfacl basic functionality"
 rlRun "setfacl -m u:root:rwx testfile" 0 "setuser root rwx permission"
 rlRun "getfacl testfile" 0 "verify ACL set"
 rlAssertGrep "user:root:rwx" "$(getfacl testfile 2>&1)" "confirm user:root:rwx alreadyset"

 rlRun "setfacl -m g:root:r-x testfile" 0 "setgroup root r-x permission"
 rlRun "getfacl testfile" 0 "verify ACL set"
 rlAssertGrep "group:root:r-x" "$(getfacl testfile 2>&1)" "confirm group:root:r-x alreadyset"

 rlRun "setfacl -m o::r-- testfile" 0 "set other onlyreadpermission"
 rlRun "getfacl testfile" 0 "verify ACL set"
 rlAssertGrep "other::r--" "$(getfacl testfile 2>&1)" "confirm other::r-- alreadyset"

 rlRun "setfacl -m m::rwx testfile" 0 "set mask is rwx"
 rlRun "getfacl testfile" 0 "verify mask set"
 rlAssertGrep "mask::rwx" "$(getfacl testfile 2>&1)" "confirm mask::rwx alreadyset"

 rlRun "setfacl -n -m u:root:r-- testfile" 0 "use -n parameternonew mask"
 rlRun "getfacl testfile" 0 "verify ACL set"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 # acl Package managed by lib.sh's reference counting auto-uninstall
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
