#!/bin/bash
# Functional test: systemd - systemd-detect-virt
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

    rlPhaseStartTest "systemd-detect-virt"
        rlRun "systemd-detect-virt" 0 "systemd-detect-virt: detect VM"
        rlRun "systemd-detect-virt -q" 0 "systemd-detect-virt -q: quiet mode"
        rlRun "systemd-detect-virt -c 2>&1 || true" 0 "systemd-detect-virt -c: container only"
        rlRun "systemd-detect-virt -v 2>&1 || true" 0 "systemd-detect-virt -v: VM only"
        rlRun "systemd-detect-virt -r 2>&1 || true" 0 "systemd-detect-virt -r: chroot only"
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
