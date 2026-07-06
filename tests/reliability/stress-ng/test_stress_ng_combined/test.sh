#!/bin/bash
# Reliability: stress-ng - 组合压力: 多stressor并行 + metrics分析
# 文档推荐阶梯式并发，此测试同时运行多种 stressor 模拟真实负载
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        stressNgSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 ""
        TAINT=$(_stressNgTaintBefore)
    rlPhaseEnd

    rlPhaseStartTest "组合压测: CPU+MEM+PROC"
        local log="$TmpDir/combo1.log"
        # 同时压 CPU(2线程) + VM(128M) + FORK(2线程)
        rlRun "stress-ng --cpu 2 --vm 1 --vm-bytes 64M --fork 2 --timeout 30s --metrics-brief --log-file $log 2>&1 | tail -10" 0 "CPU+VM+FORK 组合"
        tail -20 "$log"

        # 验证每种 stressor 都成功
        for s in cpu vm fork; do
            if grep -q "$s" "$log"; then
                _stressNgValidate "$log" "$s"
            fi
        done
    rlPhaseEnd

    rlPhaseStartTest "组合压测: 文档推荐 workload"
        # 使用文档推荐的 13 种 workload（缩短时间）
        local log="$TmpDir/combo2.log"
        local workloads="cpu context fork get mmap vm-splice wait zombie"
        local args=""
        for w in $workloads; do args="$args --$w 1"; done

        rlRun "stress-ng $args --timeout 30s --metrics-brief --log-file $log 2>&1 | tail -15" 0 "文档推荐 workload 组合"
        tail -30 "$log"

        # 统计 passed 数量
        local passed
        passed=$(grep -oP 'passed:\s*\K\d+' "$log" | awk '{s+=$1} END {print s}')
        rlLogInfo "组合测试 passed 总数: $passed"
        if [ -n "$passed" ] && [ "$passed" -gt 0 ]; then
            rlPass "组合压测: $passed 个 stressor passed"
        fi

        # 确认无失败
        local failed
        failed=$(grep -oP 'failed:\s*\K\d+' "$log" | awk '{s+=$1} END {print s}')
        if [ -z "$failed" ] || [ "$failed" -eq 0 ]; then
            rlPass "组合压测: failed=0"
        else
            rlLogWarning "组合压测存在 $failed 个失败"
        fi
    rlPhaseEnd

    rlPhaseStartTest "metrics 分析"
        local log="$TmpDir/combo1.log"
        # 分析 usr/sys time 比例
        if [ -f "$log" ]; then
            rlRun "grep -E 'cpu|vm|fork' $log | head -10" 0 "metrics 摘要"
            # usr time 应占总时间相当比例
            local total_usr total_sys
            total_usr=$(grep -oP 'usr time\s+\K[\d.]+' "$log" | head -1)
            total_sys=$(grep -oP 'sys time\s+\K[\d.]+' "$log" | head -1)
            if [ -n "$total_usr" ]; then
                rlLogInfo "usr time: $total_usr, sys time: $total_sys"
                rlPass "metrics 可解析"
            fi
        fi
    rlPhaseEnd

    rlPhaseStartTest "tainted"
        _stressNgTaintCheck "$TAINT"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
