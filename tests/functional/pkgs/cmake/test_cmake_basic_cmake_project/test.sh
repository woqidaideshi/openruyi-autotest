#!/bin/bash
# Functional test: cmake - Basic-CMake-project
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

    rlPhaseStartTest "Basic-CMake-project"
        rlRun "echo 'cmake_minimum_required(VERSION 3.10)' > $TmpDir/CMakeLists.txt" 0 "创建 CMakeLists.txt"
        rlRun "echo 'project(TestProject)' >> $TmpDir/CMakeLists.txt" 0 "添加 project 声明"
        rlRun "echo 'add_executable(hello hello.c)' >> $TmpDir/CMakeLists.txt" 0 "添加可执行目标"
        rlRun "echo 'int main(){return 0;}' > $TmpDir/hello.c" 0 "创建源文件"
        rlRun "cmake -S $TmpDir -B $TmpDir/build" 0 "cmake 配置项目"
        rlRun "test -f $TmpDir/build/CMakeCache.txt" 0 "验证 CMakeCache.txt 已生成"
        rlRun "cmake --build $TmpDir/build" 0 "cmake 构建项目"
        rlRun "test -x $TmpDir/build/hello" 0 "验证可执行文件已生成"
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
