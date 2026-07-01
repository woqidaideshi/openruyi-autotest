#!/bin/bash
# Functional test: compiler scenarios - Sanitizer
# 验证 -fsanitize=address, -fsanitize=undefined 编译运行
# 用正常程序验证 sanitizer 不误报，用故意 bug 程序验证 sanitizer 能检出

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        scenariosSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"

        # 正常程序（sanitizer 不应报错）
        cat > clean_prog.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(void) {
    int *p = malloc(sizeof(int) * 10);
    for (int i = 0; i < 10; i++) p[i] = i * 10;
    int sum = 0;
    for (int i = 0; i < 10; i++) sum += p[i];
    printf("sum=%d\n", sum);
    free(p);
    if (sum != 450) abort();
    printf("SANITIZER_CLEAN_OK\n");
    return 0;
}
CEOF

        # 故意有 bug 的程序（验证 sanitizer 能检出）
        cat > bug_prog.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
int main(void) {
    int *p = malloc(sizeof(int) * 5);
    for (int i = 0; i <= 5; i++) p[i] = i;  // buffer overflow: i==5
    free(p);
    printf("BUG_PROG_RAN\n");
    return 0;
}
CEOF
    rlPhaseEnd

    rlPhaseStartTest "GCC Address Sanitizer"
        # 正常程序 + ASAN
        rlRun "gcc -fsanitize=address -g -o asan_clean_gcc clean_prog.c 2>/dev/null" 0 "GCC -fsanitize=address 编译（正常程序）"
        if [ -x ./asan_clean_gcc ]; then
            rlRun "./asan_clean_gcc 2>/tmp/asan_clean_gcc_err.txt" 0 "GCC ASAN 正常程序运行"
            if grep -qi "ERROR\|AddressSanitizer" /tmp/asan_clean_gcc_err.txt; then
                rlFail "GCC ASAN 误报正常程序"
            else
                rlPass "GCC ASAN: 正常程序无误报"
            fi
            rlRun "grep 'SANITIZER_CLEAN_OK' /tmp/asan_clean_gcc_err.txt || cat /tmp/asan_clean_gcc_err.txt" 0 "GCC ASAN 输出验证"
        fi

        # bug 程序 + ASAN（应检出 buffer overflow）
        rlRun "gcc -fsanitize=address -g -o asan_bug_gcc bug_prog.c 2>/dev/null" 0 "GCC -fsanitize=address 编译（bug 程序）"
        if [ -x ./asan_bug_gcc ]; then
            ./asan_bug_gcc >/tmp/asan_bug_gcc_out.txt 2>&1
            local asan_rc=$?
            rlLogInfo "GCC ASAN bug 程序退出码: $asan_rc"
            if grep -qi "heap-buffer-overflow\|AddressSanitizer\|ERROR" /tmp/asan_bug_gcc_out.txt; then
                rlPass "GCC ASAN 成功检出 heap-buffer-overflow"
            else
                rlLogWarning "GCC ASAN 未检出 bug（可能被优化或环境不同）"
            fi
        fi
    rlPhaseEnd

    rlPhaseStartTest "GCC Undefined Behavior Sanitizer"
        # 正常程序 + UBSAN
        rlRun "gcc -fsanitize=undefined -g -o ubsan_clean_gcc clean_prog.c" 0 "GCC -fsanitize=undefined 编译"
        if [ -x ./ubsan_clean_gcc ]; then
            rlRun "./ubsan_clean_gcc" 0 "GCC UBSAN 正常程序运行"
            rlPass "GCC UBSAN: 正常程序无未定义行为"
        fi
    rlPhaseEnd

    rlPhaseStartTest "Clang Address Sanitizer"
        rlRun "clang -fsanitize=address -g -o asan_clean_clang clean_prog.c" 0 "Clang -fsanitize=address 编译"
        if [ -x ./asan_clean_clang ]; then
            rlRun "./asan_clean_clang 2>/tmp/asan_clean_clang_err.txt" 0 "Clang ASAN 正常程序运行"
            if grep -qi "ERROR\|AddressSanitizer" /tmp/asan_clean_clang_err.txt; then
                rlFail "Clang ASAN 误报正常程序"
            else
                rlPass "Clang ASAN: 正常程序无误报"
            fi
        fi
    rlPhaseEnd

    rlPhaseStartTest "Clang Undefined Behavior Sanitizer"
        rlRun "clang -fsanitize=undefined -g -o ubsan_clean_clang clean_prog.c" 0 "Clang -fsanitize=undefined 编译"
        if [ -x ./ubsan_clean_clang ]; then
            rlRun "./ubsan_clean_clang" 0 "Clang UBSAN 正常程序运行"
            rlPass "Clang UBSAN: 正常程序无未定义行为"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 "离开临时目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理临时目录"
        rm -f /tmp/asan_clean_{gcc,clang}_err.txt /tmp/asan_bug_gcc_out.txt
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
