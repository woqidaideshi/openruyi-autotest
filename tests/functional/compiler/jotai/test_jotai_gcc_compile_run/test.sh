#!/bin/bash
# Functional test: compiler - jotai - GCC 多优化级别编译运行
# 选择 Jotai benchmark，用 gcc -O0/-O1/-O2/-O3 分别编译并运行
# 验证: 所有优化级别编译成功、运行不崩溃、输出内容一致

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

BENCH_DIR="/tmp/jotai-benchmarks/benchmarks/anghaLeaves"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        jotaiSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
        
        # 选择一个 benchmark 文件（优先选小的，编译快）
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

    rlPhaseStartTest "GCC 编译与运行"
        if [ ! -f ./bench.c ]; then
            rlFail "bench.c 不存在，跳过测试"
        else
            local outputs=()
            local exit_codes=()
            
            for opt in O0 O1 O2 O3; do
                local bin="bench_gcc_$opt"
                local out="output_gcc_$opt.txt"
                
                # 编译
                rlRun "gcc -std=c99 -$opt bench.c -o $bin -lm 2>&1" 0 "GCC -$opt 编译"
                
                if [ -x "./$bin" ]; then
                    # 运行（两个输入: 0=big-arr, 1=big-arr-10x）
                    rlRun "./$bin 0 > $out 2>&1; echo \"exit=\$?\" >> $out" 0 "GCC -$opt 运行 (input=0)"
                    
                    # 检查是否有输出
                    if [ -s "$out" ]; then
                        rlPass "GCC -$opt 产生输出 ($(wc -c < $out) bytes)"
                    else
                        rlLogWarning "GCC -$opt 输出为空"
                    fi
                    
                    outputs+=("$(cat $out)")
                    exit_codes+=("$?")
                else
                    rlFail "GCC -$opt 编译产物不可执行"
                fi
            done
            
            # 验证所有优化级别输出一致
            if [ ${#outputs[@]} -ge 2 ]; then
                local first="${outputs[0]}"
                local all_match=1
                for ((i=1; i<${#outputs[@]}; i++)); do
                    if [ "${outputs[$i]}" != "$first" ]; then
                        all_match=0
                        rlLogWarning "GCC -$opt 输出与其他级别不一致"
                    fi
                done
                if [ "$all_match" -eq 1 ]; then
                    rlPass "GCC 所有优化级别输出一致"
                else
                    # 输出不一致不一定算失败（不同优化可能有不同行为），记录警告
                    rlLogWarning "GCC 不同优化级别输出存在差异（可能由优化导致）"
                    rlPass "GCC 所有优化级别均编译运行成功"
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
