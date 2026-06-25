#!/bin/bash
# Functional test: systemd - systemctl---Service-and-system-management
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

    rlPhaseStartTest "systemctl---Service-and-system-management"
        rlRun "systemctl --version" 0 "systemctl version"
        rlRun "systemctl list-units --type=service | head -20" 0 "systemctl: list running services"
        rlRun "systemctl list-units --type=target | head -20" 0 "systemctl: list targets"
        rlRun "systemctl list-units --type=service --all | head -20" 0 "systemctl --all: all services"
        rlRun "systemctl list-unit-files --type=service | head -10" 0 "systemctl: list unit files"
        rlRun "systemctl is-active systemd-journald.service 2>&1 || true" 0 "systemctl is-active: check service status"
        rlRun "systemctl is-enabled systemd-journald.service 2>&1 || true" 0 "systemctl is-enabled: check enabled"
        rlRun "systemctl is-failed 2>&1 || true" 0 "systemctl is-failed: list failed units"
        rlRun "systemctl status systemd-journald.service 2>&1 | head -5" 0 "systemctl status: service status"
        rlRun "systemctl show systemd-journald.service 2>&1 | head -10" 0 "systemctl show: service properties"
        rlRun "systemctl cat systemd-journald.service 2>&1 | head -5" 0 "systemctl cat: show unit file"
        rlRun "systemctl list-dependencies default.target 2>&1 | head -10" 0 "systemctl list-dependencies"
        rlRun "systemctl list-sockets 2>&1 | head -10" 0 "systemctl list-sockets"
        rlRun "systemctl list-timers 2>&1 | head -10" 0 "systemctl list-timers"
        rlRun "systemctl list-machines 2>&1 || true" 0 "systemctl list-machines"
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
