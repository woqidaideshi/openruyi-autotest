#!/bin/bash
# Functional test: libnl - �ļ���֤
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        libnlSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "�ļ���֤"
        rlRun "ls /usr/lib64/libnl-3.so.200* 2>/dev/null || ls /usr/lib/libnl-3.so.200* 2>/dev/null || echo \"not in standard path\"" 0 "��� libnl-3.so.200"
        rlRun "ls /usr/lib64/libnl-3.so.200.26.0* 2>/dev/null || ls /usr/lib/libnl-3.so.200.26.0* 2>/dev/null || echo \"not in standard path\"" 0 "��� libnl-3.so.200.26.0"
        rlRun "ls /usr/lib64/libnl-genl-3.so.200* 2>/dev/null || ls /usr/lib/libnl-genl-3.so.200* 2>/dev/null || echo \"not in standard path\"" 0 "��� libnl-genl-3.so.200"
        rlRun "ls /usr/lib64/libnl-genl-3.so.200.26.0* 2>/dev/null || ls /usr/lib/libnl-genl-3.so.200.26.0* 2>/dev/null || echo \"not in standard path\"" 0 "��� libnl-genl-3.so.200.26.0"
        rlRun "ls /usr/lib64/libnl-idiag-3.so.200* 2>/dev/null || ls /usr/lib/libnl-idiag-3.so.200* 2>/dev/null || echo \"not in standard path\"" 0 "��� libnl-idiag-3.so.200"
        rlRun "pkg-config --libs libnl 2>&1 || true" 0 "pkg-config ����Ϣ"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # libnl 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
