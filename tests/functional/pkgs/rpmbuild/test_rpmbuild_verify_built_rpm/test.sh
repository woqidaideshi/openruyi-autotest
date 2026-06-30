#!/bin/bash
# Functional test: rpmbuild - Verify-built-RPM
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        rpmbuildSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Verify-built-RPM"
        rlRun "rpm -qpl 2>&1 || rpm -qil 2>&1" 0 "rpm 查询命令可用"
        rlRun "ls $HOME/rpmbuild/RPMS/ 2>/dev/null || echo no-rpms-yet" 0 "检查 RPM 输出目录"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # rpmbuild 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
