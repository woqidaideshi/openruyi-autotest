#!/bin/bash
# Functional test: coreutils - System-information--uname--who--whoami--id--groups
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        coreutilsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
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


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # coreutils 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
