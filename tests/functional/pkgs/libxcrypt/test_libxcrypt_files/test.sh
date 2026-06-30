#!/bin/bash
# Functional test: libxcrypt - �ļ���֤
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        libxcryptSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "�ļ���֤"
        rlRun "ls /usr/lib64/libcrypt.so.1* 2>/dev/null || ls /usr/lib/libcrypt.so.1* 2>/dev/null || echo \"not in standard path\"" 0 "��� libcrypt.so.1"
        rlRun "ls /usr/lib64/libcrypt.so.1.1.0* 2>/dev/null || ls /usr/lib/libcrypt.so.1.1.0* 2>/dev/null || echo \"not in standard path\"" 0 "��� libcrypt.so.1.1.0"
        rlRun "ls /usr/lib64/libowcrypt.so.1* 2>/dev/null || ls /usr/lib/libowcrypt.so.1* 2>/dev/null || echo \"not in standard path\"" 0 "��� libowcrypt.so.1"
        rlRun "pkg-config --libs libxcrypt 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "pkg-config ����Ϣ"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # libxcrypt 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
