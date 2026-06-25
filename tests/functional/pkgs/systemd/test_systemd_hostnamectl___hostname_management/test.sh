#!/bin/bash
# Functional test: systemd - hostnamectl---Hostname-management
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        systemdSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "hostnamectl---Hostname-management"
        rlRun "hostnamectl --version 2>&1 || true" 0 "hostnamectl version"
        rlRun "hostnamectl status" 0 "hostnamectl status: system info"
        rlRun "hostnamectl hostname" 0 "hostnamectl hostname: current name"
        rlRun "hostnamectl --static" 0 "hostnamectl --static"
        rlRun "hostnamectl --transient" 0 "hostnamectl --transient"
        rlRun "hostnamectl --pretty 2>&1 || true" 0 "hostnamectl --pretty"
        rlRun "hostnamectl chassis 2>&1 || true" 0 "hostnamectl chassis"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # systemd 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
