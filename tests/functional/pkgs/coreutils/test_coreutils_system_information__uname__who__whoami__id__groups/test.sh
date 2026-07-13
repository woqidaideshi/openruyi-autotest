#!/bin/bash
# Functional test: coreutils - System-information--uname--who--whoami--id--groups
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

 rlPhaseStartTest "System-information--uname--who--whoami--id--groups"
 rlRun "uname" 0 "uname system name"
 rlRun "uname -a" 0 "uname -a all info"
 rlRun "uname -r" 0 "uname -r kernel release"
 rlRun "uname -m" 0 "uname -m machine hardware"
 rlRun "who" 0 "who show logged in users"
 rlRun "whoami" 0 "whoami current user"
 rlRun "id" 0 "id user identity"
 rlRun "id -u" 0 "id -u user ID"
 rlRun "id -g" 0 "id -g group ID"
 rlRun "groups" 0 "groups show group membership"
 rlRun "groups $(whoami)" 0 "groups for specific user"
 rlRun "users" 0 "users list logged in users"
 rlRun "hostid" 0 "hostid numeric host identifier"
 rlRun "nproc" 0 "nproc number of CPUs"
 rlRun "nproc --all" 0 "nproc --all all processors"
 rlRun "tty" 0 "tty terminal name"
 rlRun "logname" 0 "logname login name"
 rlRun "pinky" 0 "pinky user info"
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
