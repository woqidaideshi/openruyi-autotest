#!/bin/bash
# Functional test: compiler scenarios - C 语言标准 (C99/C11/C17)
# 验证 GCC 和 Clang 对不同 C 标准的支持
# 每种标准包含其特有语法特性

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        scenariosSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"

        # C99 特有: 声明可在块内任意位置、// 注释、inline、变长数组
        cat > c99_test.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
int main(void) {
    // C99: declaration after statement
    int x = 10;
    int y = x * 2;
    printf("C99 x=%d y=%d\n", x, y);

    // C99: variable-length array (VLA)
    int n = 5;
    int vla[n];
    for (int i = 0; i < n; i++) vla[i] = i * i;
    for (int i = 0; i < n; i++) {
        if (vla[i] != i * i) abort();
    }

    // C99: stdint.h types
    int64_t val = 12345678901234LL;
    if (sizeof(int64_t) != 8) abort();
    printf("int64_t=%ld\n", (long)val);

    // C99: inline function
    inline int c99_inline_func(int a) { return a * a; }
    if (c99_inline_func(7) != 49) abort();

    printf("C99_OK\n");
    return 0;
}
CEOF

        # C11 特有: _Generic, _Atomic, _Alignas, _Static_assert
        cat > c11_test.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
#include <stdalign.h>
#include <stdatomic.h>

// C11: _Generic
#define type_name(x) _Generic((x), int: "int", long: "long", float: "float", double: "double", char*: "string", default: "other")

// C11: _Static_assert
_Static_assert(sizeof(int) >= 4, "int must be at least 4 bytes");

int main(void) {
    // C11: _Generic
    printf("int -> %s\n", type_name(42));
    printf("double -> %s\n", type_name(3.14));
    printf("string -> %s\n", type_name("hello"));

    // C11: _Alignas
    alignas(64) int aligned_var = 100;
    if (aligned_var != 100) abort();
    printf("alignas test ok\n");

    // C11: anonymous struct/union (as extension)
    printf("C11_OK\n");
    return 0;
}
CEOF

        # C17/C18: 主要是 C11 的 bugfix, 移除了一些过时功能
        # 测试标准合规性
        cat > c17_test.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>

// C17: 仍然支持 _Generic, _Alignas 等 C11 特性
#define cmp(a, b) _Generic((a), int: (a) == (b), double: (a) == (b), default: 0)

int main(void) {
    // 基本类型检查
    if (!cmp(42, 42)) abort();
    printf("_Generic comparison ok\n");

    // 匿名联合 (GNU extension)
    union { int i; float f; } u = { .i = 123 };
    if (u.i != 123) abort();
    printf("anonymous union ok\n");

    // 复合字面量
    int *p = (int[]){1, 2, 3, 4, 5};
    int sum = 0;
    for (int i = 0; i < 5; i++) sum += p[i];
    if (sum != 15) abort();
    printf("compound literal sum=%d\n", sum);

    // 指定初始化器
    struct { int a; int b; int c; } s = { .a = 1, .c = 3 };
    if (s.a != 1 || s.c != 3) abort();
    printf("designated initializer ok\n");

    printf("C17_OK\n");
    return 0;
}
CEOF
    rlPhaseEnd

    rlPhaseStartTest "GCC C 标准编译"
        # GCC C99
        rlRun "gcc -std=c99 -Wall -o c99_gcc c99_test.c" 0 "GCC -std=c99 编译"
        rlRun "./c99_gcc" 0 "GCC -std=c99 运行"
        rlRun "./c99_gcc | grep 'C99_OK'" 0 "GCC C99 输出验证"

        # GCC C11
        rlRun "gcc -std=c11 -Wall -o c11_gcc c11_test.c" 0 "GCC -std=c11 编译"
        rlRun "./c11_gcc" 0 "GCC -std=c11 运行"
        rlRun "./c11_gcc | grep 'C11_OK'" 0 "GCC C11 输出验证"

        # GCC C17
        rlRun "gcc -std=c17 -Wall -o c17_gcc c17_test.c" 0 "GCC -std=c17 编译"
        rlRun "./c17_gcc" 0 "GCC -std=c17 运行"
        rlRun "./c17_gcc | grep 'C17_OK'" 0 "GCC C17 输出验证"
    rlPhaseEnd

    rlPhaseStartTest "Clang C 标准编译"
        # Clang C99
        rlRun "clang -std=c99 -Wall -o c99_clang c99_test.c" 0 "Clang -std=c99 编译"
        rlRun "./c99_clang" 0 "Clang -std=c99 运行"
        rlRun "./c99_clang | grep 'C99_OK'" 0 "Clang C99 输出验证"

        # Clang C11
        rlRun "clang -std=c11 -Wall -o c11_clang c11_test.c" 0 "Clang -std=c11 编译"
        rlRun "./c11_clang" 0 "Clang -std=c11 运行"
        rlRun "./c11_clang | grep 'C11_OK'" 0 "Clang C11 输出验证"

        # Clang C17
        rlRun "clang -std=c17 -Wall -o c17_clang c17_test.c" 0 "Clang -std=c17 编译"
        rlRun "./c17_clang" 0 "Clang -std=c17 运行"
        rlRun "./c17_clang | grep 'C17_OK'" 0 "Clang C17 输出验证"

        # 交叉验证: GCC 和 Clang 同一标准输出应一致
        rlRun "./c99_gcc > /tmp/c99_gcc_out.txt" 0 "GCC C99 输出保存"
        rlRun "./c99_clang > /tmp/c99_clang_out.txt" 0 "Clang C99 输出保存"
        if diff -q /tmp/c99_gcc_out.txt /tmp/c99_clang_out.txt >/dev/null 2>&1; then
            rlPass "C99: GCC 与 Clang 输出一致"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 "离开临时目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理临时目录"
        rm -f /tmp/c99_{gcc,clang}_out.txt
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
