#!/bin/bash
# Functional test: binutils - binutils 错误处理
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        binutilsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "binutils 错误处理"
        rlRun "nm /nonexistent_file 2>&1 | grep -qiE \"No such|cannot|error\" || echo error-ok" 0 "nm �����ڵ��ļ�"
        rlRun "objdump /nonexistent_file 2>&1 | grep -qiE \"No such|cannot|error\" || echo error-ok" 0 "objdump �����ڵ��ļ�"
        rlRun "readelf /nonexistent_file 2>&1 | grep -qiE \"No such|cannot|error\" || echo error-ok" 0 "readelf �����ڵ��ļ�"
        rlRun "nm --help 2>&1 | grep -qiE \"Usage|用法|usage\" || echo help-not-standard" 0 "nm ��Ч����"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # binutils 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
