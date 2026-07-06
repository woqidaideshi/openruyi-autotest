#!/bin/bash
# Functional test: compiler - yarpgen - 差分测试（G++ vs Clang 输出对比）
# 核心: G++ 与 Clang 编译同一 YARPGen 随机程序后运行比较输出
# 输出不一致意味着某个编译器存在优化 Bug

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

YARPGEN_BIN="/tmp/yarpgen/build/yarpgen"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        yarpgenSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
        
        if [ ! -x "$YARPGEN_BIN" ]; then
            rlFail "yarpgen 不可用，跳过测试"
        fi
    rlPhaseEnd

    rlPhaseStartTest "差分测试"
        local diff_failures=0
        local total_tests=0
        
        # 运行 3 轮差分测试
        for round in 1 2 3; do
            rlLogInfo "======== YARPGen 差分测试 第 ${round} 轮 ========"
            
            # 创建独立目录
            mkdir -p "round_${round}"
            cd "round_${round}"
            
            # 生成随机程序
            $YARPGEN_BIN > /tmp/yarpgen_gen_${round}.log 2>&1
            if [ ! -f "driver.cpp" ] || [ ! -f "func.cpp" ]; then
                rlFail "第 ${round} 轮: YARPGen 程序生成失败"
                cd "$TmpDir"
                continue
            fi
            
            total_tests=$((total_tests + 1))
            rlLogInfo "第 ${round} 轮: 生成成功 (func.cpp: $(wc -l < func.cpp) 行, driver.cpp: $(wc -l < driver.cpp) 行)"
            
            # G++ 编译
            g++ -fPIC func.cpp driver.cpp -o test_gxx -O2 2>/tmp/yarpgen_diff_gxx_err_${round}.txt
            local gxx_rc=$?
            
            # Clang 编译
            clang++ -fPIC func.cpp driver.cpp -o test_clang -O2 2>/tmp/yarpgen_diff_clang_err_${round}.txt
            local clang_rc=$?
            
            if [ "$gxx_rc" -ne 0 ]; then
                rlFail "第 ${round} 轮: G++ 编译失败"
                cd "$TmpDir"
                continue
            fi
            
            if [ "$clang_rc" -ne 0 ]; then
                rlFail "第 ${round} 轮: Clang 编译失败"
                cd "$TmpDir"
                continue
            fi
            
            rlPass "第 ${round} 轮: G++ 和 Clang 均编译成功"
            
            # 运行并捕获输出
            timeout 10 ./test_gxx > gxx_output.txt 2>/tmp/yarpgen_run_gxx_${round}.txt
            local gxx_run_rc=$?
            
            timeout 10 ./test_clang > clang_output.txt 2>/tmp/yarpgen_run_clang_${round}.txt
            local clang_run_rc=$?
            
            # 检查运行崩溃
            if grep -qi "segmentation fault\|core dumped\|stack\|abort" /tmp/yarpgen_run_gxx_${round}.txt 2>/dev/null; then
                rlLogWarning "第 ${round} 轮: G++ 运行时可能崩溃"
            fi
            if grep -qi "segmentation fault\|core dumped\|stack\|abort" /tmp/yarpgen_run_clang_${round}.txt 2>/dev/null; then
                rlLogWarning "第 ${round} 轮: Clang 运行时可能崩溃"
            fi
            
            # 核心: 输出对比
            if [ -f "gxx_output.txt" ] && [ -f "clang_output.txt" ]; then
                if diff -q gxx_output.txt clang_output.txt >/dev/null 2>&1; then
                    rlPass "第 ${round} 轮: G++ 与 Clang 输出一致 ✓"
                else
                    diff_failures=$((diff_failures + 1))
                    
                    # 显示差异
                    echo "=== 输出差异 ==="
                    diff gxx_output.txt clang_output.txt | head -30
                    echo "=== G++ 输出 ==="
                    cat gxx_output.txt
                    echo "=== Clang 输出 ==="  
                    cat clang_output.txt
                    
                    rlFail "第 ${round} 轮: 差分测试失败 — G++/Clang 输出不一致（可能存在编译器优化 Bug）"
                fi
            else
                rlFail "第 ${round} 轮: 输出文件缺失"
            fi
            
            cd "$TmpDir"
        done
        
        # 总结
        rlLogInfo "YARPGen 差分测试完成: $total_tests 轮, $diff_failures 个不一致"
        if [ "$diff_failures" -eq 0 ] && [ "$total_tests" -gt 0 ]; then
            rlPass "所有 YARPGen 差分测试通过: 无编译器输出不一致"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 "离开临时目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理临时目录"
        rm -f /tmp/yarpgen_{gen,diff_{gxx,clang}_err,run_{gxx,clang}}_*.txt
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
