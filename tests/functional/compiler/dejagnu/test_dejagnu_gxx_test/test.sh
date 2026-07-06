#!/bin/bash
# Functional test: compiler - dejagnu - G++ 编译测试用例
# 创建最小 C++ 测试程序，用 DejaGnu runtest 框架执行并验证结果

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        dejagnuSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
        
        # 创建 G++ testsuite 目录结构
        mkdir -p gxx-testsuite/g++.dg
        
        # 创建测试用的 C++ 源文件
        cat > gxx-testsuite/g++.dg/dejagnu_gxx_test.C << 'CEOF'
// { dg-do run }
// { dg-options "-O2 -std=c++17" }
#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <numeric>
#include <cmath>

int main() {
    // 模板测试
    std::vector<int> vec = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    
    // STL 算法测试
    int sum = std::accumulate(vec.begin(), vec.end(), 0);
    if (sum != 55) abort();
    
    // Lambda 表达式测试
    auto square = [](int x) { return x * x; };
    std::vector<int> squares;
    std::transform(vec.begin(), vec.end(), std::back_inserter(squares), square);
    if (squares[0] != 1 || squares[9] != 100) abort();
    
    // 字符串测试
    std::string s = "g++";
    s += " dejagnu";
    s += " test passed";
    if (s.find("passed") == std::string::npos) abort();
    
    // 浮点测试
    double d = std::sqrt(144.0);
    if (std::abs(d - 12.0) > 0.0001) abort();
    
    std::cout << "GXX_DG_TEST_PASSED" << std::endl;
    return 0;
}
CEOF
        
        # 创建 DejaGnu .exp 文件
        cat > gxx-testsuite/g++.dg/dejagnu_gxx_test.exp << 'EEOF'
# G++ DejaGnu test driver
load_lib g++-dg.exp

dg-init
dg-runtest "$srcdir/$subdir/dejagnu_gxx_test.C" "-O2 -std=c++17" ""
dg-finish
EEOF
        
        rlLogInfo "G++ 测试文件已创建"
    rlPhaseEnd

    rlPhaseStartTest "G++ DejaGnu 测试"
        cd gxx-testsuite
        
        export GCC_UNDER_TEST=gcc
        export GXX_UNDER_TEST=g++
        
        runtest --tool g++ g++.dg/dejagnu_gxx_test.exp 2>&1 | tee /tmp/dejagnu_gxx_run.log
        local rc=${PIPESTATUS[0]}
        
        # 验证 .sum 文件
        if [ -f g++.sum ]; then
            rlRun "cat g++.sum" 0 "显示 g++.sum 内容"
            
            if grep -q "^PASS:" g++.sum; then
                local pass_count
                pass_count=$(grep -c "^PASS:" g++.sum)
                rlPass "G++ DejaGnu 测试通过 ($pass_count 个 PASS)"
            else
                rlFail "G++ .sum 文件未包含 PASS 结果"
            fi
            
            if grep -q "^FAIL:" g++.sum; then
                local fail_count
                fail_count=$(grep -c "^FAIL:" g++.sum)
                rlFail "G++ 测试存在 $fail_count 个失败"
            else
                rlPass "G++ 测试无 FAIL"
            fi
        else
            rlFail "未生成 g++.sum 文件"
        fi
        
        # 验证 .log 文件
        if [ -f g++.log ]; then
            if grep -q "GXX_DG_TEST_PASSED\|PASS\|dg-runtest" g++.log; then
                rlPass "g++.log 包含预期输出"
            fi
        fi
        
        cd "$TmpDir"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 "离开临时目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理临时目录"
        rm -f /tmp/dejagnu_gxx_run.log
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
