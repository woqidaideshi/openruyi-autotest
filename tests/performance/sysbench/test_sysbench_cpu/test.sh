#!/bin/bash
# Performance: sysbench - CPU 计算性能: prime number benchmark
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        sysbenchSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 ""
    rlPhaseEnd

    rlPhaseStartTest "单核 CPU"
        local log="/tmp/sb_cpu_1.log"
        rlLogInfo "=== CPU 单核 (--threads=1) ==="
        sysbench --threads=1 --cpu-max-prime=40000 --time=30 --report-interval=5 cpu run 2>&1 | tee "$log"
        _sysbenchParse "$log"
        local eps
        eps=$(grep "events per second" "$log" | grep -oP '[\d.]+' | head -1)
        [ -n "$eps" ] && rlPass "单核 CPU: ${eps} events/s" || rlFail "无数据"
    rlPhaseEnd

    rlPhaseStartTest "多核 CPU"
        local cores=$(nproc)
        local log="/tmp/sb_cpu_n.log"
        rlLogInfo "=== CPU 多核 (--threads=$cores) ==="
        sysbench --threads=$cores --cpu-max-prime=40000 --time=30 --report-interval=5 cpu run 2>&1 | tee "$log"
        _sysbenchParse "$log"
        local eps
        eps=$(grep "events per second" "$log" | grep -oP '[\d.]+' | head -1)
        [ -n "$eps" ] && rlPass "多核 CPU ($cores): ${eps} events/s" || rlFail "无数据"
    rlPhaseEnd

    rlPhaseStartTest "单核 vs 多核 对比"
        local eps1 epsN
        eps1=$(grep "events per second" /tmp/sb_cpu_1.log | grep -oP '[\d.]+' | head -1)
        epsN=$(grep "events per second" /tmp/sb_cpu_n.log | grep -oP '[\d.]+' | head -1)
        if [ -n "$eps1" ] && [ -n "$epsN" ]; then
            rlLogInfo "单核: ${eps1} eps, 多核($(nproc)): ${epsN} eps"
        fi
        rlPass "CPU 对比分析完成"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
        rm -f /tmp/sb_cpu_*.log
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
