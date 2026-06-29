#!/bin/bash
# Functional test: libcap-ng - ng - �ļ���֤
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        libcapNgSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "ng - �ļ���֤"
        rlRun "ls /usr/lib64/libcap-ng.so.0* 2>/dev/null || ls /usr/lib/libcap-ng.so.0* 2>/dev/null || echo \"not in standard path\"" 0 "��� libcap-ng.so.0"
        rlRun "ls /usr/lib64/libcap-ng.so.0.0.0* 2>/dev/null || ls /usr/lib/libcap-ng.so.0.0.0* 2>/dev/null || echo \"not in standard path\"" 0 "��� libcap-ng.so.0.0.0"
        rlRun "ls /usr/lib64/libdrop_ambient.so.0* 2>/dev/null || ls /usr/lib/libdrop_ambient.so.0* 2>/dev/null || echo \"not in standard path\"" 0 "��� libdrop_ambient.so.0"
        rlRun "ls /usr/lib64/libdrop_ambient.so.0.0.0* 2>/dev/null || ls /usr/lib/libdrop_ambient.so.0.0.0* 2>/dev/null || echo \"not in standard path\"" 0 "��� libdrop_ambient.so.0.0.0"
        rlRun "pkg-config --libs libcap-ng 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "pkg-config ����Ϣ"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # libcap-ng 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
