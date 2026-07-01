#!/bin/bash
# Functional test: compiler - dejagnu - GCC 编译测试用例
# 创建最小 GCC 测试程序，用 DejaGnu runtest 框架执行并验证结果

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        dejagnuSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
        
        # 创建 GCC testsuite 目录结构
        mkdir -p gcc-testsuite/gcc.dg
        
        # 创建测试用的 C 源文件
        cat > gcc-testsuite/gcc.dg/dejagnu_test.c << 'CEOF'
/* { dg-do run } */
/* { dg-options "-O2" } */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
    /* 基本算术测试 */
    int a = 42, b = 58, c = a + b;
    if (c != 100) abort();
    
    /* 字符串测试 */
    char buf[32];
    snprintf(buf, sizeof(buf), "gcc test %d", c);
    if (strcmp(buf, "gcc test 100") != 0) abort();
    
    /* 内存操作测试 */
    int arr[10] = {0,1,2,3,4,5,6,7,8,9};
    int sum = 0;
    for (int i = 0; i < 10; i++) sum += arr[i];
    if (sum != 45) abort();
    
    printf("GCC_DG_TEST_PASSED\n");
    return 0;
}
CEOF
        
        # 创建 DejaGnu .exp 文件
        cat > gcc-testsuite/gcc.dg/dejagnu_test.exp << 'EEOF'
# GCC DejaGnu test driver
load_lib gcc-dg.exp

dg-init
dg-runtest "$srcdir/$subdir/dejagnu_test.c" "-O2" ""
dg-finish
EEOF
        
        rlLogInfo "测试文件已创建"
    rlPhaseEnd

    rlPhaseStartTest "GCC DejaGnu 测试"
        # 进入 testsuite 目录执行 runtest
        cd gcc-testsuite
        
        # 设置 GCC 工具路径
        export GCC_UNDER_TEST=gcc
        export GXX_UNDER_TEST=g++
        
        runtest --tool gcc gcc.dg/dejagnu_test.exp 2>&1 | tee /tmp/dejagnu_gcc_run.log
        local rc=${PIPESTATUS[0]}
        
        rlRun "ls -la gcc.log gcc.sum 2>/dev/null || true" 0 "检查 .log/.sum 文件"
        
        # 验证 .sum 文件内容
        if [ -f gcc.sum ]; then
            rlRun "cat gcc.sum" 0 "显示 .sum 内容"
            
            # 检查是否有 PASS 标记
            if grep -q "^PASS:" gcc.sum; then
                local pass_count
                pass_count=$(grep -c "^PASS:" gcc.sum)
                rlPass "GCC DejaGnu 测试通过 ($pass_count 个 PASS)"
            else
                rlFail "GCC .sum 文件未包含 PASS 结果"
            fi
            
            # 检查不应有 FAIL
            if grep -q "^FAIL:" gcc.sum; then
                local fail_count
                fail_count=$(grep -c "^FAIL:" gcc.sum)
                rlFail "GCC 测试存在 $fail_count 个失败"
            else
                rlPass "GCC 测试无 FAIL"
            fi
        else
            rlFail "未生成 gcc.sum 文件"
        fi
        
        # 验证 .log 文件包含编译/运行输出
        if [ -f gcc.log ]; then
            if grep -q "GCC_DG_TEST_PASSED\|PASS\|dg-runtest" gcc.log; then
                rlPass "gcc.log 包含预期测试输出"
            fi
        fi
        
        cd "$TmpDir"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 "离开临时目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理临时目录"
        rm -f /tmp/dejagnu_gcc_run.log
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
