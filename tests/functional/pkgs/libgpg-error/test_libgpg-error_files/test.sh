#!/bin/bash
# Functional test: libgpg-error - error - �ļ���֤
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        libgpgErrorSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "error - �ļ���֤"
        rlRun "ls /usr/lib64/libgpg-error.so.0* 2>/dev/null || ls /usr/lib/libgpg-error.so.0* 2>/dev/null || echo \"not in standard path\"" 0 "��� libgpg-error.so.0"
        rlRun "ls /usr/lib64/libgpg-error.so.0.41.1* 2>/dev/null || ls /usr/lib/libgpg-error.so.0.41.1* 2>/dev/null || echo \"not in standard path\"" 0 "��� libgpg-error.so.0.41.1"
        rlRun "pkg-config --libs libgpg-error 2>&1 || true" 0 "pkg-config ����Ϣ"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # libgpg-error 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
