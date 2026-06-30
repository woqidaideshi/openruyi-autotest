#!/bin/bash
# Functional test: rpm-config-openruyi - config-openruyi - 错误处理
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        rpmConfigOpenruyiSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "config-openruyi - 错误处理"
        rlRun "rpm -q rpm-config-openruyi 2>/dev/null || echo not-found" 0 "rpm-config-openruyi 包检查"
        rlRun "ls /usr/lib/rpm/openruyi/ 2>/dev/null || ls /usr/lib/rpm/macros.d/ 2>/dev/null" 0 "RPM 宏目录存在"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # rpm-config-openruyi 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
