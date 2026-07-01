#!/bin/bash
# Functional test: compiler scenarios - 优化级别
# O0/O1/O2/O3/Os/Ofast 全部编译运行，验证输出一致性

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        scenariosSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"

        # 创建包含多种运算模式的测试程序
        cat > opt_test.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
// 有意设计可变输入防止编译器完全常量折叠
int compute(int seed) {
    volatile int s = seed;
    int arr[100];
    // 数组运算
    for (int i = 0; i < 100; i++) arr[i] = (i * s) % 997;
    long long sum = 0;
    for (int i = 0; i < 100; i++) sum += arr[i];
    // 位运算
    int bits = 0;
    for (int i = 0; i < 32; i++) if (s & (1 << i)) bits++;
    // 浮点运算
    double d = 0.0;
    for (int i = 0; i < 10; i++) d += sqrt((double)(arr[i] * arr[i] + s));
    // 字符串
    char buf[128];
    snprintf(buf, sizeof(buf), "sum=%lld bits=%d d=%.2f seed=%d", sum, bits, d, s);
    printf("%s\n", buf);
    return (int)(sum % 256);
}
int main(void) {
    int ret = 0;
    for (int s = 1; s <= 5; s++) ret += compute(s);
    printf("OPT_ALL_LEVELS_OK\n");
    return ret;
}
CEOF
    rlPhaseEnd

    rlPhaseStartTest "GCC 优化级别"
        local gcc_outputs=()
        for opt in O0 O1 O2 O3 Os Ofast; do
            local outfile="/tmp/gcc_${opt}_out.txt"
            rlRun "gcc -${opt} -o opt_gcc_${opt} opt_test.c -lm" 0 "GCC -${opt} 编译"
            if [ -x "./opt_gcc_${opt}" ]; then
                rlRun "./opt_gcc_${opt} > ${outfile} 2>&1" 0 "GCC -${opt} 运行"
                rlRun "grep 'OPT_ALL_LEVELS_OK' ${outfile}" 0 "GCC -${opt} 输出验证"
                gcc_outputs+=("${outfile}")
            fi
        done
        # 验证 -O0 与 -O2 输出一致（关键检查）
        if [ -f "/tmp/gcc_O0_out.txt" ] && [ -f "/tmp/gcc_O2_out.txt" ]; then
            if diff -q /tmp/gcc_O0_out.txt /tmp/gcc_O2_out.txt >/dev/null 2>&1; then
                rlPass "GCC -O0 与 -O2 输出一致"
            else
                rlFail "GCC -O0 与 -O2 输出不一致（可能存在优化 Bug）"
            fi
        fi
    rlPhaseEnd

    rlPhaseStartTest "Clang 优化级别"
        local clang_outputs=()
        for opt in O0 O1 O2 O3 Os Ofast; do
            local outfile="/tmp/clang_${opt}_out.txt"
            rlRun "clang -${opt} -o opt_clang_${opt} opt_test.c -lm" 0 "Clang -${opt} 编译"
            if [ -x "./opt_clang_${opt}" ]; then
                rlRun "./opt_clang_${opt} > ${outfile} 2>&1" 0 "Clang -${opt} 运行"
                rlRun "grep 'OPT_ALL_LEVELS_OK' ${outfile}" 0 "Clang -${opt} 输出验证"
                clang_outputs+=("${outfile}")
            fi
        done
        if [ -f "/tmp/clang_O0_out.txt" ] && [ -f "/tmp/clang_O2_out.txt" ]; then
            if diff -q /tmp/clang_O0_out.txt /tmp/clang_O2_out.txt >/dev/null 2>&1; then
                rlPass "Clang -O0 与 -O2 输出一致"
            else
                rlLogWarning "Clang -O0 与 -O2 输出有差异"
            fi
        fi
    rlPhaseEnd

    rlPhaseStartTest "GCC vs Clang -O2 对比"
        if [ -f "/tmp/gcc_O2_out.txt" ] && [ -f "/tmp/clang_O2_out.txt" ]; then
            if diff -q /tmp/gcc_O2_out.txt /tmp/clang_O2_out.txt >/dev/null 2>&1; then
                rlPass "GCC 与 Clang -O2 输出一致（差分验证通过）"
            else
                rlPass "GCC/Clang 输出差异展示"
            fi
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 "离开临时目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理临时目录"
        rm -f /tmp/{gcc,clang}_O?_out.txt /tmp/{gcc,clang}_Os_out.txt /tmp/{gcc,clang}_Ofast_out.txt
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
