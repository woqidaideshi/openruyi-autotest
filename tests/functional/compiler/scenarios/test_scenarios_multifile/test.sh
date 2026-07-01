#!/bin/bash
# Functional test: compiler scenarios - 多文件分离编译 + C/C++ 混合
# 多个 .c 文件分别编译后链接，C 和 C++ 混合链接（extern "C"）

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        scenariosSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"

        # 文件 1: string_utils.c
        cat > string_utils.c << 'CEOF'
#include <string.h>
#include <ctype.h>
int str_count_vowels(const char *s) {
    int count = 0;
    for (; *s; s++) {
        char c = tolower((unsigned char)*s);
        if (c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u')
            count++;
    }
    return count;
}
int str_count_digits(const char *s) {
    int count = 0;
    for (; *s; s++) {
        if (*s >= '0' && *s <= '9') count++;
    }
    return count;
}
CEOF

        cat > string_utils.h << 'CEOF'
#ifndef STRING_UTILS_H
#define STRING_UTILS_H
#ifdef __cplusplus
extern "C" {
#endif
int str_count_vowels(const char *s);
int str_count_digits(const char *s);
#ifdef __cplusplus
}
#endif
#endif
CEOF

        # 文件 2: math_ops.c
        cat > math_ops.c << 'CEOF'
int factorial(int n) {
    int result = 1;
    for (int i = 2; i <= n; i++) result *= i;
    return result;
}
int gcd(int a, int b) {
    while (b != 0) { int t = b; b = a % b; a = t; }
    return a;
}
CEOF

        cat > math_ops.h << 'CEOF'
#ifndef MATH_OPS_H
#define MATH_OPS_H
#ifdef __cplusplus
extern "C" {
#endif
int factorial(int n);
int gcd(int a, int b);
#ifdef __cplusplus
}
#endif
#endif
CEOF

        # 文件 3: main.cpp (C++ 主程序调用 C 函数)
        cat > main_prog.cpp << 'CEOF'
#include <iostream>
#include <string>
#include "string_utils.h"
#include "math_ops.h"
using namespace std;
int main() {
    // 调用 C 函数
    int vowels = str_count_vowels("Hello World 2024");
    int digits = str_count_digits("Hello World 2024");
    int fact5 = factorial(5);
    int gcd_val = gcd(48, 18);
    cout << "vowels=" << vowels << " digits=" << digits
         << " factorial5=" << fact5 << " gcd(48,18)=" << gcd_val << endl;
    // 验证
    bool ok = true;
    if (vowels != 3) { cerr << "vowel count error" << endl; ok = false; }
    if (digits != 4) { cerr << "digit count error" << endl; ok = false; }
    if (fact5 != 120) { cerr << "factorial error" << endl; ok = false; }
    if (gcd_val != 6) { cerr << "gcd error" << endl; ok = false; }
    if (ok) cout << "MULTIFILE_C_CXX_OK" << endl;
    return ok ? 0 : 1;
}
CEOF
    rlPhaseEnd

    rlPhaseStartTest "GCC 多文件分离编译"
        # 分离编译 C 文件
        rlRun "gcc -c string_utils.c -o string_utils.o" 0 "GCC 编译 string_utils.o"
        rlRun "gcc -c math_ops.c -o math_ops.o" 0 "GCC 编译 math_ops.o"

        # 链接所有目标文件
        rlRun "g++ -o multifile_gxx main_prog.cpp string_utils.o math_ops.o" 0 "G++ 链接 C + C++ 目标文件"
        rlAssertExists multifile_gxx
        rlRun "./multifile_gxx" 0 "多文件程序运行"
        rlRun "./multifile_gxx | grep 'MULTIFILE_C_CXX_OK'" 0 "多文件 C/C++ 混合验证"

        # 一步编译（源码直接链接）
        rlRun "g++ -o multifile_one_gxx main_prog.cpp string_utils.c math_ops.c" 0 "G++ 一步编译多文件"
        rlRun "./multifile_one_gxx | grep 'MULTIFILE_C_CXX_OK'" 0 "一步编译验证"
    rlPhaseEnd

    rlPhaseStartTest "Clang 多文件分离编译"
        rlRun "clang -c string_utils.c -o string_utils_clang.o" 0 "Clang 编译 string_utils.o"
        rlRun "clang -c math_ops.c -o math_ops_clang.o" 0 "Clang 编译 math_ops.o"
        rlRun "clang++ -o multifile_clang main_prog.cpp string_utils_clang.o math_ops_clang.o" 0 "Clang++ 链接"
        rlRun "./multifile_clang | grep 'MULTIFILE_C_CXX_OK'" 0 "Clang 多文件 C/C++ 混合验证"
    rlPhaseEnd

    rlPhaseStartTest "跨编译器目标文件链接"
        # GCC 编译的 .o + Clang 链接
        rlRun "clang++ -o multifile_cross1 main_prog.cpp string_utils.o math_ops.o 2>&1" 0 "Clang++ 链接 GCC .o"
        if [ -x ./multifile_cross1 ]; then
            rlRun "./multifile_cross1 | grep 'MULTIFILE_C_CXX_OK'" 0 "跨编译器链接验证 1"
        fi

        # Clang 编译的 .o + GCC 链接
        rlRun "g++ -o multifile_cross2 main_prog.cpp string_utils_clang.o math_ops_clang.o 2>&1" 0 "G++ 链接 Clang .o"
        if [ -x ./multifile_cross2 ]; then
            rlRun "./multifile_cross2 | grep 'MULTIFILE_C_CXX_OK'" 0 "跨编译器链接验证 2"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 "离开临时目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理临时目录"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
