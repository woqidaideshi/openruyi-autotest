#!/bin/bash
# Functional test: compiler scenarios - 链接场景
# 静态库 (.a)、动态库 (.so)、-fPIC 编译和链接

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        scenariosSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"

        # 库源码
        cat > math_util.c << 'CEOF'
int add(int a, int b) { return a + b; }
int multiply(int a, int b) { return a * b; }
int divide(int a, int b) { return b != 0 ? a / b : -1; }
const char *lib_version(void) { return "math_util_v1.0"; }
CEOF

        cat > math_util.h << 'CEOF'
#ifndef MATH_UTIL_H
#define MATH_UTIL_H
int add(int a, int b);
int multiply(int a, int b);
int divide(int a, int b);
const char *lib_version(void);
#endif
CEOF

        # 使用库的主程序
        cat > main_prog.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
#include "math_util.h"
int main(void) {
    int a = add(10, 20);
    int m = multiply(6, 7);
    int d = divide(100, 4);
    const char *ver = lib_version();
    printf("add=%d multiply=%d divide=%d ver=%s\n", a, m, d, ver);
    if (a != 30 || m != 42 || d != 25) abort();
    printf("LINK_OK\n");
    return 0;
}
CEOF
    rlPhaseEnd

    rlPhaseStartTest "GCC 静态库"
        # 编译目标文件
        rlRun "gcc -c math_util.c -o math_util.o" 0 "GCC 编译目标文件"
        # 创建静态库
        rlRun "ar rcs libmath_util.a math_util.o" 0 "ar 创建静态库"
        rlAssertExists "libmath_util.a"
        # 链接静态库
        rlRun "gcc main_prog.c -L. -lmath_util -o prog_static_gcc" 0 "GCC 静态库链接"
        rlRun "./prog_static_gcc | grep 'LINK_OK'" 0 "GCC 静态库运行验证"
        # 检查静态链接后二进制大小（应包含库代码）
        rlRun "ls -la prog_static_gcc" 0 "静态链接产物信息"
    rlPhaseEnd

    rlPhaseStartTest "GCC 动态库"
        # -fPIC 编译
        rlRun "gcc -fPIC -c math_util.c -o math_util_pic.o" 0 "GCC -fPIC 编译"
        # 创建动态库
        rlRun "gcc -shared -o libmath_util.so math_util_pic.o" 0 "GCC 创建动态库 (.so)"
        rlAssertExists "libmath_util.so"
        # 链接动态库
        rlRun "gcc main_prog.c -L. -lmath_util -o prog_dynamic_gcc" 0 "GCC 动态库链接"
        # 设置 LD_LIBRARY_PATH 运行
        rlRun "LD_LIBRARY_PATH=. ./prog_dynamic_gcc" 0 "GCC 动态库运行"
        rlRun "LD_LIBRARY_PATH=. ./prog_dynamic_gcc | grep 'LINK_OK'" 0 "GCC 动态库输出验证"
        # 检查动态链接
        rlRun "ldd prog_dynamic_gcc | grep libmath_util" 0 "ldd 检查动态库依赖"
    rlPhaseEnd

    rlPhaseStartTest "Clang 静态和动态库"
        # Clang 静态库
        rlRun "clang -c math_util.c -o math_util_clang.o" 0 "Clang 编译目标文件"
        rlRun "ar rcs libmath_util_clang.a math_util_clang.o" 0 "ar 创建 Clang 静态库"
        rlRun "clang main_prog.c -L. -lmath_util_clang -o prog_static_clang" 0 "Clang 静态库链接"
        rlRun "./prog_static_clang | grep 'LINK_OK'" 0 "Clang 静态库验证"

        # Clang 动态库
        rlRun "clang -fPIC -c math_util.c -o math_util_clang_pic.o" 0 "Clang -fPIC 编译"
        rlRun "clang -shared -o libmath_util_clang.so math_util_clang_pic.o" 0 "Clang 动态库"
        rlRun "clang main_prog.c -L. -lmath_util_clang -o prog_dynamic_clang" 0 "Clang 动态库链接"
        rlRun "LD_LIBRARY_PATH=. ./prog_dynamic_clang | grep 'LINK_OK'" 0 "Clang 动态库验证"
    rlPhaseEnd

    rlPhaseStartTest "跨编译器链接"
        # GCC 编译的库 + Clang 主程序
        rlRun "clang main_prog.c -L. -lmath_util -o prog_cross1" 0 "Clang 链接 GCC 库"
        rlRun "LD_LIBRARY_PATH=. ./prog_cross1 | grep 'LINK_OK'" 0 "跨编译器链接验证 (GCC 库 + Clang 程序)"

        # Clang 编译的库 + GCC 主程序
        rlRun "gcc main_prog.c -L. -lmath_util_clang -o prog_cross2" 0 "GCC 链接 Clang 库"
        rlRun "LD_LIBRARY_PATH=. ./prog_cross2 | grep 'LINK_OK'" 0 "跨编译器链接验证 (Clang 库 + GCC 程序)"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 "离开临时目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理临时目录"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
