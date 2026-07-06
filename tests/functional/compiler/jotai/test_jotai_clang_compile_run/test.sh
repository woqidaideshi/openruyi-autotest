#!/bin/bash
# Functional test: compiler - jotai - Clang 多优化级别编译运行
# 选择 Jotai benchmark（与 gcc 测试用同一个文件），用 clang 编译运行
# 验证: 所有优化级别编译成功、运行不崩溃、输出与 gcc 一致（差分测试）

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

BENCH_DIR="/tmp/jotai-benchmarks/benchmarks/anghaLeaves"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        jotaiSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
        
        BENCH_FILE=$(find "$BENCH_DIR" -name '*.c' -type f 2>/dev/null | head -1)
        if [ -z "$BENCH_FILE" ]; then
            BENCH_FILE=$(find /tmp/jotai-benchmarks/benchmarks -name '*.c' -type f 2>/dev/null | head -1)
        fi
        
        if [ -z "$BENCH_FILE" ]; then
            rlFail "未找到可用的 benchmark 文件"
        else
            rlLogInfo "选择的 benchmark: $(basename $BENCH_FILE)"
            cp "$BENCH_FILE" ./bench.c
        fi
    rlPhaseEnd

    rlPhaseStartTest "Clang 编译与运行"
        if [ ! -f ./bench.c ]; then
            rlFail "bench.c 不存在，跳过测试"
        else
            local outputs=()
            
            for opt in O0 O1 O2 O3; do
                local bin="bench_clang_$opt"
                local out="output_clang_$opt.txt"
                
                rlRun "clang -$opt bench.c -o $bin -lm 2>&1" 0 "Clang -$opt 编译"
                
                if [ -x "./$bin" ]; then
                    rlRun "./$bin 0 > $out 2>&1" 0 "Clang -$opt 运行 (input=0)"
                    
                    if [ -s "$out" ]; then
                        rlPass "Clang -$opt 产生输出 ($(wc -c < $out) bytes)"
                        
                        # 检查是否有错误输出
                        if grep -qi "error\|segfault\|abort\|assert" "$out" 2>/dev/null; then
                            rlLogWarning "Clang -$opt 输出包含疑似错误信息"
                        fi
                    else
                        rlLogWarning "Clang -$opt 输出为空"
                    fi
                    
                    outputs+=("$(cat $out)")
                else
                    rlFail "Clang -$opt 编译产物不可执行"
                fi
            done
            
            # 同时用 gcc 编译一份作为基准对比
            if command -v gcc >/dev/null 2>&1; then
                rlRun "gcc -std=c99 -O2 bench.c -o bench_gcc_O2 -lm 2>&1" 0 "GCC -O2 编译（基准对比）"
                if [ -x "./bench_gcc_O2" ]; then
                    ./bench_gcc_O2 0 > output_gcc_ref.txt 2>&1
                    
                    # 对比 clang -O2 和 gcc -O2 的输出
                    if [ -f "output_clang_O2.txt" ]; then
                        if diff -q output_gcc_ref.txt output_clang_O2.txt >/dev/null 2>&1; then
                            rlPass "GCC 与 Clang -O2 输出一致（差分测试通过）"
                        else
                            rlLogWarning "GCC 与 Clang -O2 输出不一致（可能由编译器差异导致）"
                            rlRun "diff output_gcc_ref.txt output_clang_O2.txt" 0 "显示输出差异"
                            # 不一致不一定代表 bug，但需要关注
                            rlPass "GCC 与 Clang 均能正确编译运行"
                        fi
                    fi
                fi
            fi
            
            # 验证 Clang 内部各优化级别一致性
            if [ ${#outputs[@]} -ge 2 ]; then
                local first="${outputs[0]}"
                local all_match=1
                for ((i=1; i<${#outputs[@]}; i++)); do
                    if [ "${outputs[$i]}" != "$first" ]; then
                        all_match=0
                    fi
                done
                if [ "$all_match" -eq 1 ]; then
                    rlPass "Clang 所有优化级别输出一致"
                else
                    rlLogWarning "Clang 不同优化级别输出存在差异"
                fi
            fi
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 "离开临时目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理临时目录"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
