#!/bin/bash
# Functional test: cmake - CMake--E-mode
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        cmakeSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "CMake--E-mode"
        rlRun "cmake -E echo 'hello'" 0 "cmake -E echo 输出文本"
        rlRun "cmake -E make_directory $TmpDir/testdir" 0 "cmake -E make_directory 创建目录"
        rlRun "test -d $TmpDir/testdir" 0 "验证目录已创建"
        rlRun "cmake -E touch $TmpDir/testdir/test.txt" 0 "cmake -E touch 创建文件"
        rlRun "test -f $TmpDir/testdir/test.txt" 0 "验证文件已创建"
        rlRun "cmake -E copy $TmpDir/testdir/test.txt $TmpDir/testdir/test2.txt" 0 "cmake -E copy 复制文件"
        rlRun "test -f $TmpDir/testdir/test2.txt" 0 "验证副本已创建"
        rlRun "cmake -E remove $TmpDir/testdir/test2.txt" 0 "cmake -E remove 删除文件"
        rlRun "cmake -E remove_directory $TmpDir/testdir" 0 "cmake -E remove_directory 删除目录"
        rlRun "cmake -E environment 2>&1 | grep -q PATH" 0 "cmake -E environment 显示环境变量"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # cmake 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
