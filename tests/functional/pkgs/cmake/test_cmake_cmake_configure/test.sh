#!/bin/bash
# Functional test: cmake - CMake-configure
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

    rlPhaseStartTest "CMake-configure"
        rlRun "echo 'cmake_minimum_required(VERSION 3.10)' > $TmpDir/CMakeLists.txt" 0 "创建最小 CMakeLists.txt"
        rlRun "echo 'project(ConfigTest)' >> $TmpDir/CMakeLists.txt" 0 "声明项目"
        rlRun "cmake -S $TmpDir -B $TmpDir/build1 -D CMAKE_BUILD_TYPE=Release" 0 "cmake 配置 Release 构建"
        rlRun "grep -q CMAKE_BUILD_TYPE:STRING=Release $TmpDir/build1/CMakeCache.txt" 0 "验证 Release 配置已设置"
        rlRun "cmake -S $TmpDir -B $TmpDir/build2 -D CMAKE_C_COMPILER=$(which gcc)" 0 "cmake 指定 C 编译器"
        rlRun "test -f $TmpDir/build2/CMakeCache.txt" 0 "验证第二次配置成功"
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
