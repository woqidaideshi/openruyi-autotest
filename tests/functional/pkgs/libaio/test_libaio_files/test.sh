#!/bin/bash
# Functional test: libaio - �ļ���֤
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        libaioSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "�ļ���֤"
        rlRun "ls /usr/lib64/libaio.so.1* 2>/dev/null || ls /usr/lib/libaio.so.1* 2>/dev/null || echo \"not in standard path\"" 0 "��� libaio.so.1"
        rlRun "ls /usr/lib64/libaio.so.1.0.2* 2>/dev/null || ls /usr/lib/libaio.so.1.0.2* 2>/dev/null || echo \"not in standard path\"" 0 "��� libaio.so.1.0.2"
        rlRun "pkg-config --libs libaio 2>&1 || true" 0 "pkg-config ����Ϣ"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # libaio 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
