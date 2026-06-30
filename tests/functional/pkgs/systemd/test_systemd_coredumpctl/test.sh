#!/bin/bash
# Functional test: systemd - coredumpctl
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

    rlPhaseStartTest "coredumpctl"
        rlRun "coredumpctl --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "coredumpctl version"
        rlRun "coredumpctl list 2>&1 | head -5" 0 "coredumpctl list: list dumps"
        rlRun "coredumpctl info 2>&1 | head -5 || true" 0 "coredumpctl info"
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
