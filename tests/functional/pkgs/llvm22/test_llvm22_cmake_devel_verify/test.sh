#!/bin/bash
# Functional test: llvm22-devel - cmake 导出完整性验证
# 验证 llvm22-devel 包提供的 .cmake 文件引用的所有文件是否真实存在
# 对应 issue: https://github.com/openRuyi-Project/openRuyi/issues/760
# 问题: LLVMExports.cmake 引用了不存在的 .a 文件（如 libLLVMTestingAnnotations.a）
#      导致 find_package(LLVM) 在配置阶段就直接失败
#
# 验证原理:
#   find_package(LLVM) → LLVMConfig.cmake → LLVMExports.cmake
#   LLVMExports.cmake 是唯一列出所有 target→文件映射的文件，
#   加载时会校验每个 target 引用的 .a/.so 是否真实存在。
#   其他 .cmake 文件（AddLLVM、CheckAtomic 等）是内部构建辅助模块，
#   不在 find_package 时加载，且不包含文件路径引用，
#   不会产生 issue#760 类问题，无需单独验证。

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        llvm22Setup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"

        # 自动发现 LLVM cmake 目录
        LLVM_CMAKE_DIR=$(rpm -ql llvm22-devel | grep 'LLVMConfig\.cmake$' | head -1 | xargs dirname)
        rlLogInfo "LLVM cmake 目录: $LLVM_CMAKE_DIR"

        # 统计 .cmake 文件数量
        CMAKE_COUNT=$(rpm -ql llvm22-devel | grep -c '\.cmake$')
        rlLogInfo "llvm22-devel 提供了 $CMAKE_COUNT 个 .cmake 文件"
    rlPhaseEnd

    rlPhaseStartTest "find_package(LLVM) COMPONENTS - 校验 LLVMExports.cmake 导出完整性"
        if [ "$CMAKE_COUNT" -eq 0 ]; then
            rlLogWarning "llvm22-devel 未提供任何 .cmake 文件，跳过 cmake 校验"
        else
            cat > "$TmpDir/CMakeLists.txt" << 'CMAKEEOF'
cmake_minimum_required(VERSION 3.13.4)
project(llvm_devel_components_test
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(LLVM REQUIRED CONFIG
  COMPONENTS
    core
    support
    bitwriter
    irreader
)

message(STATUS "LLVM package with COMPONENTS found successfully")
message(STATUS "LLVM version: ${LLVM_VERSION}")
CMAKEEOF

            rlRun "cmake -S $TmpDir -B $TmpDir/build_components" 0 \
                "cmake 配置 (find_package LLVM with COMPONENTS)"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd