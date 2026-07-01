#!/bin/bash
# Functional test: compiler scenarios - 预处理器
# 验证 -E, -D, -I, 宏展开、条件编译

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        scenariosSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"

        # 创建带预处理指令的源文件
        cat > preproc_test.c << 'CEOF'
#include <stdio.h>
#include "include_test.h"  // -I 搜索路径测试
// -D 定义的宏
#ifndef VERSION
#define VERSION "unknown"
#endif
#ifndef EXTRA_FEATURE
#define EXTRA_FEATURE 0
#endif
int main(void) {
    printf("VERSION=%s\n", VERSION);
    printf("EXTRA_FEATURE=%d\n", EXTRA_FEATURE);
#ifdef HAVE_SPECIAL
    printf("SPECIAL=1\n");
#else
    printf("SPECIAL=0\n");
#endif
    printf("PREPROC_OK\n");
    return 0;
}
CEOF

        mkdir -p include_dir
        cat > include_dir/include_test.h << 'CEOF'
#define HEADER_FLAG 1
#define HEADER_MSG "included_ok"
CEOF

        cat > macro_test.c << 'CEOF'
#include <stdio.h>
#define STRINGIFY(x) #x
#define CONCAT(a, b) a ## b
#define SQUARE(x) ((x) * (x))
int main(void) {
    // # 字符串化
    printf("STRING=%s\n", STRINGIFY(hello_world));
    // ## 连接
    int xy = 100;
    printf("CONCAT=%d\n", CONCAT(x, y));
    // 宏展开
    printf("SQUARE=%d\n", SQUARE(5));
    printf("MACRO_OK\n");
    return 0;
}
CEOF
    rlPhaseEnd

    rlPhaseStartTest "GCC 预处理"
        # -E: 仅预处理
        rlRun "gcc -E preproc_test.c 2>/dev/null | tee /tmp/preproc_e.txt" 0 "GCC -E 仅预处理"
        rlRun "grep 'main' /tmp/preproc_e.txt" 0 "预处理输出包含 main 函数"

        # -D: 定义宏
        rlRun "gcc -DVERSION=\\\"2.0.1\\\" -DEXTRA_FEATURE=42 -DHAVE_SPECIAL -Iinclude_dir -o preproc_gcc preproc_test.c" 0 "GCC -D/-I 编译"
        rlRun "./preproc_gcc | tee /tmp/preproc_out.txt" 0 "GCC 预处理器宏运行"
        rlRun "grep 'VERSION=2.0.1' /tmp/preproc_out.txt" 0 "VERSION 宏正确"
        rlRun "grep 'EXTRA_FEATURE=42' /tmp/preproc_out.txt" 0 "EXTRA_FEATURE 宏正确"
        rlRun "grep 'SPECIAL=1' /tmp/preproc_out.txt" 0 "HAVE_SPECIAL 条件编译正确"
        rlRun "grep 'PREPROC_OK' /tmp/preproc_out.txt" 0 "预处理器测试通过"

        # 字符串化和连接
        rlRun "gcc -o macro_gcc macro_test.c" 0 "GCC 宏测试编译"
        rlRun "./macro_gcc | tee /tmp/macro_out.txt" 0 "GCC 宏测试运行"
        rlRun "grep 'STRING=hello_world' /tmp/macro_out.txt" 0 "# 字符串化正确"
        rlRun "grep 'CONCAT=100' /tmp/macro_out.txt" 0 "## 连接正确"
        rlRun "grep 'SQUARE=25' /tmp/macro_out.txt" 0 "宏展开正确"
    rlPhaseEnd

    rlPhaseStartTest "Clang 预处理"
        rlRun "clang -E preproc_test.c 2>/dev/null | head -50" 0 "Clang -E 仅预处理"
        rlRun "clang -DVERSION=\\\"2.0.1\\\" -DHAVE_SPECIAL -Iinclude_dir -o preproc_clang preproc_test.c" 0 "Clang -D/-I 编译"
        rlRun "./preproc_clang | grep 'SPECIAL=1'" 0 "Clang 条件编译正确"
        rlRun "./preproc_clang | grep 'PREPROC_OK'" 0 "Clang 预处理器测试通过"

        rlRun "clang -o macro_clang macro_test.c" 0 "Clang 宏测试编译"
        rlRun "./macro_clang | grep 'MACRO_OK'" 0 "Clang 宏展开正确"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 "离开临时目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理临时目录"
        rm -f /tmp/preproc_{e,out}.txt /tmp/macro_out.txt
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
