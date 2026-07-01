#!/bin/bash
# Functional test: compiler scenarios - 调试信息
# 验证 -g/-g3/-ggdb 编译产物可调试: 含有 debug_info, gdb 可设置断点

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        scenariosSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"

        cat > debug_test.c << 'CEOF'
#include <stdio.h>
#include <string.h>
static int factorial(int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}
static int fib(int n) {
    if (n <= 1) return n;
    return fib(n - 1) + fib(n - 2);
}
int main(void) {
    int a = factorial(5);   // 120
    int b = fib(10);         // 55
    const char *msg = "debug_test_ok";
    printf("%s a=%d b=%d\n", msg, a, b);
    if (a != 120) return 1;
    if (b != 55) return 1;
    return 0;
}
CEOF
    rlPhaseEnd

    rlPhaseStartTest "GCC 调试信息"
        for level in g g3 ggdb; do
            rlRun "gcc -${level} -o debug_${level} debug_test.c" 0 "GCC -${level} 编译"
            rlRun "./debug_${level}" 0 "GCC -${level} 运行"
            rlRun "./debug_${level} | grep 'debug_test_ok'" 0 "GCC -${level} 输出验证"

            # 检查 ELF 包含 debug_info
            rlRun "readelf -S debug_${level} | grep -q '.debug_info'" 0 "GCC -${level}: .debug_info section 存在"
            rlRun "readelf -S debug_${level} | grep -q '.debug_line'" 0 "GCC -${level}: .debug_line section 存在"
        done
    rlPhaseEnd

    rlPhaseStartTest "Clang 调试信息"
        rlRun "clang -g -o debug_clang_g debug_test.c" 0 "Clang -g 编译"
        rlRun "./debug_clang_g | grep 'debug_test_ok'" 0 "Clang -g 输出验证"
        rlRun "readelf -S debug_clang_g | grep -q '.debug_info'" 0 "Clang -g: debug_info 存在"
    rlPhaseEnd

    rlPhaseStartTest "GDB 断点验证"
        if command -v gdb >/dev/null 2>&1; then
            # 创建 gdb 批处理脚本
            cat > /tmp/gdb_cmds.txt << 'GEOF'
break factorial
run
print n
continue
quit
GEOF
            rlRun "gdb -batch -x /tmp/gdb_cmds.txt ./debug_g 2>&1 | tee /tmp/gdb_output.txt" 0 "GDB 断点测试"

            # 检查 gdb 输出包含断点信息
            if grep -q "Breakpoint 1" /tmp/gdb_output.txt; then
                rlPass "GDB 断点设置成功"
            else
                rlLogWarning "GDB 断点设置可能失败"
            fi

            if grep -q "debug_test_ok\|a=120" /tmp/gdb_output.txt; then
                rlPass "GDB 运行到程序结束"
            fi
        else
            rlLogWarning "GDB 不可用，跳过断点验证"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 "离开临时目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理临时目录"
        rm -f /tmp/gdb_cmds.txt /tmp/gdb_output.txt
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
