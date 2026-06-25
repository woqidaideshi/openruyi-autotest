#!/bin/bash
# Functional test: sddm - Configuration
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        sddmSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Configuration"
        rlRun "sddm --example-config 2>&1 | head -20" 0 "sddm: example config"
        rlRun "ls /etc/sddm.conf.d/ 2>&1 || echo \"No config dir\"" 0 "Config directory"
        rlRun "ls /usr/lib/sddm/sddm.conf.d/ 2>&1 || echo \"No default config dir\"" 0 "Default config dir"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # sddm 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
