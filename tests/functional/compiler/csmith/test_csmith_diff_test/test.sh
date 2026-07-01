#!/bin/bash
# Functional test: compiler - csmith - 差分测试（GCC vs Clang 输出对比）
# 核心测试: 同一 Csmith 随机程序用 gcc 和 clang 编译后运行
# 比较输出 — 如果输出不一致，说明某个编译器有 Bug

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        csmithSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
        
        # 生成 3 个不同的随机程序，提高发现 bug 的概率
        for i in 1 2 3; do
            rlRun "csmith > csmith_diff_${i}.c 2>/dev/null" 0 "生成随机程序 #${i}"
        done
    rlPhaseEnd

    rlPhaseStartTest "差分测试"
        local diff_failures=0
        local total_tests=0
        
        for i in 1 2 3; do
            local src="csmith_diff_${i}.c"
            local gcc_bin="csmith_diff_${i}_gcc"
            local clang_bin="csmith_diff_${i}_clang"
            local gcc_out="csmith_diff_${i}_gcc_out.txt"
            local clang_out="csmith_diff_${i}_clang_out.txt"
            
            rlLogInfo "=== 差分测试 #${i} ==="
            total_tests=$((total_tests + 1))
            
            # GCC 编译
            if gcc -O2 "$src" -o "$gcc_bin" -w 2>/dev/null; then
                rlPass "测试 #${i}: GCC 编译成功"
            else
                rlFail "测试 #${i}: GCC 编译失败"
                continue
            fi
            
            # Clang 编译
            if clang -O2 "$src" -o "$clang_bin" -w 2>/dev/null; then
                rlPass "测试 #${i}: Clang 编译成功"
            else
                rlFail "测试 #${i}: Clang 编译失败"
                continue
            fi
            
            # GCC 运行
            timeout 10 ./"$gcc_bin" > "$gcc_out" 2>/tmp/csmith_gcc_runerr_${i}.txt
            local gcc_run_rc=$?
            
            # Clang 运行
            timeout 10 ./"$clang_bin" > "$clang_out" 2>/tmp/csmith_clang_runerr_${i}.txt
            local clang_run_rc=$?
            
            # 检查运行退出码
            if [ "$gcc_run_rc" -ne 0 ]; then
                rlLogWarning "测试 #${i}: GCC 运行时退出码非 0: $gcc_run_rc"
            fi
            if [ "$clang_run_rc" -ne 0 ]; then
                rlLogWarning "测试 #${i}: Clang 运行时退出码非 0: $clang_run_rc"
            fi
            
            # 检查是否有运行错误
            local has_error=0
            if grep -qi "segmentation fault\|core dumped\|stack smash\|buffer overflow" /tmp/csmith_gcc_runerr_${i}.txt 2>/dev/null; then
                rlLogWarning "测试 #${i}: GCC 运行时检测到崩溃/错误"
                has_error=1
            fi
            if grep -qi "segmentation fault\|core dumped\|stack smash\|buffer overflow" /tmp/csmith_clang_runerr_${i}.txt 2>/dev/null; then
                rlLogWarning "测试 #${i}: Clang 运行时检测到崩溃/错误"
                has_error=1
            fi
            
            # 核心: 输出对比
            if [ -f "$gcc_out" ] && [ -f "$clang_out" ]; then
                if diff -q "$gcc_out" "$clang_out" >/dev/null 2>&1; then
                    rlPass "测试 #${i}: GCC 与 Clang 输出一致 ✓"
                else
                    diff_failures=$((diff_failures + 1))
                    rlLogWarning "测试 #${i}: GCC 与 Clang 输出不一致！"
                    
                    # 显示差异（最多显示前 20 行）
                    rlRun "diff $gcc_out $clang_out | head -20" 0 "输出差异 (前 20 行)"
                    
                    # 检查是否有未定义行为（UB）导致的差异 — Csmith 生成的是标准 C，理论上应一致
                    rlFail "测试 #${i}: 差分测试失败 — GCC/Clang 输出不一致（可能存在编译器 Bug）"
                fi
            else
                rlFail "测试 #${i}: 未能生成输出文件"
            fi
            
            # 检查两个输出都非空
            if [ -s "$gcc_out" ] && [ -s "$clang_out" ]; then
                rlPass "测试 #${i}: 两个编译器均产生有效输出"
            else
                rlLogWarning "测试 #${i}: 输出文件为空"
            fi
        done
        
        # 总结
        rlLogInfo "差分测试完成: $total_tests 个程序, $diff_failures 个不一致"
        if [ "$diff_failures" -eq 0 ]; then
            rlPass "所有差分测试通过: 无编译器输出不一致"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 "离开临时目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理临时目录"
        rm -f /tmp/csmith_{gcc,clang}_runerr_*.txt
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
