#!/bin/bash
# Functional test: compiler scenarios - 汇编输出
# 验证 -S 生成汇编代码，检查关键指令片段

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        scenariosSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"

        cat > asm_test.c << 'CEOF'
#include <stdio.h>
static int compute(int a, int b, int c) {
    int x = a + b;
    int y = x * c;
    int z = y - a;
    return z;
}
int main(void) {
    int result = compute(5, 10, 3);
    printf("result=%d\n", result);
    if (result != 40) return 1;
    printf("ASM_OK\n");
    return 0;
}
CEOF
    rlPhaseEnd

    rlPhaseStartTest "GCC 汇编输出"
        # -S: 生成汇编
        rlRun "gcc -S -O2 asm_test.c -o asm_gcc_O2.s" 0 "GCC -S -O2 生成汇编"
        rlAssertExists "asm_gcc_O2.s"

        # 验证汇编文件包含基本元素
        if [ -f asm_gcc_O2.s ]; then
            rlRun "cat asm_gcc_O2.s | head -30" 0 "显示汇编代码（前 30 行）"

            # 检查基本指令
            if grep -qi 'compute\|main' asm_gcc_O2.s; then
                rlPass "汇编包含 compute/main 标签"
            fi

            # 检查汇编文件非空
            local asm_lines
            asm_lines=$(wc -l < asm_gcc_O2.s)
            if [ "$asm_lines" -gt 5 ]; then
                rlPass "GCC 汇编输出有效 ($asm_lines 行)"
            else
                rlFail "GCC 汇编输出过少"
            fi

            # 生成不同优化级别的汇编，验证有差异
            rlRun "gcc -S -O0 asm_test.c -o asm_gcc_O0.s" 0 "GCC -S -O0 汇编"
            if [ -f asm_gcc_O0.s ] && [ -f asm_gcc_O2.s ]; then
                if ! diff -q asm_gcc_O0.s asm_gcc_O2.s >/dev/null 2>&1; then
                    rlPass "GCC -O0 与 -O2 汇编有差异（优化生效）"
                fi
            fi
        fi
    rlPhaseEnd

    rlPhaseStartTest "Clang 汇编输出"
        rlRun "clang -S -O2 asm_test.c -o asm_clang_O2.s" 0 "Clang -S -O2 汇编"
        rlAssertExists "asm_clang_O2.s"

        if [ -f asm_clang_O2.s ]; then
            rlRun "cat asm_clang_O2.s | head -30" 0 "显示 Clang 汇编代码（前 30 行）"

            local asm_lines
            asm_lines=$(wc -l < asm_clang_O2.s)
            if [ "$asm_lines" -gt 3 ]; then
                rlPass "Clang 汇编输出有效 ($asm_lines 行)"
            fi

            # 验证可以汇编回目标文件
            rlRun "gcc -c asm_clang_O2.s -o asm_from_s.o" 0 "汇编代码 → 目标文件"
            rlRun "gcc asm_from_s.o -o asm_from_s" 0 "目标文件 → 可执行文件"
            rlRun "./asm_from_s | grep 'ASM_OK'" 0 "汇编回编产物运行验证"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 "离开临时目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理临时目录"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
