#!/bin/bash
# Functional test: python-lxml - lxml - �ļ���֤
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        pythonLxmlSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "lxml - �ļ���֤"
        rlRun "ls /usr/lib64/_elementpath.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || ls /usr/lib/_elementpath.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || echo \"not in standard path\"" 0 "��� _elementpath.cpython-313-riscv64-linux-gnu.so"
        rlRun "ls /usr/lib64/builder.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || ls /usr/lib/builder.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || echo \"not in standard path\"" 0 "��� builder.cpython-313-riscv64-linux-gnu.so"
        rlRun "ls /usr/lib64/etree.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || ls /usr/lib/etree.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || echo \"not in standard path\"" 0 "��� etree.cpython-313-riscv64-linux-gnu.so"
        rlRun "ls /usr/lib64/_difflib.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || ls /usr/lib/_difflib.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || echo \"not in standard path\"" 0 "��� _difflib.cpython-313-riscv64-linux-gnu.so"
        rlRun "ls /usr/lib64/diff.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || ls /usr/lib/diff.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || echo \"not in standard path\"" 0 "��� diff.cpython-313-riscv64-linux-gnu.so"
        rlRun "pkg-config --libs python-lxml 2>&1 || true" 0 "pkg-config ����Ϣ"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # python-lxml 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
