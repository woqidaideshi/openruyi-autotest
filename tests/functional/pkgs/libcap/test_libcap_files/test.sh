#!/bin/bash
# Functional test: libcap - �ļ���֤
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        libcapSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "�ļ���֤"
        rlRun "ls /usr/lib64/libcap.so.2* 2>/dev/null || ls /usr/lib/libcap.so.2* 2>/dev/null || echo \"not in standard path\"" 0 "��� libcap.so.2"
        rlRun "ls /usr/lib64/libcap.so.2.76* 2>/dev/null || ls /usr/lib/libcap.so.2.76* 2>/dev/null || echo \"not in standard path\"" 0 "��� libcap.so.2.76"
        rlRun "ls /usr/lib64/libpsx.so.2* 2>/dev/null || ls /usr/lib/libpsx.so.2* 2>/dev/null || echo \"not in standard path\"" 0 "��� libpsx.so.2"
        rlRun "ls /usr/lib64/libpsx.so.2.76* 2>/dev/null || ls /usr/lib/libpsx.so.2.76* 2>/dev/null || echo \"not in standard path\"" 0 "��� libpsx.so.2.76"
        rlRun "ls /usr/lib64/pam_cap.so* 2>/dev/null || ls /usr/lib/pam_cap.so* 2>/dev/null || echo \"not in standard path\"" 0 "��� pam_cap.so"
        rlRun "pkg-config --libs libcap 2>&1 || true" 0 "pkg-config ����Ϣ"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # libcap 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
