#!/bin/bash
# Performance test: UnixBench - UnixBench 快速模式 (单线程核心测试)
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        unixbenchSetup
        rlRun "cd $UNIXBENCH_DIR/UnixBench" 0 "进入 UnixBench 目录"

    rlPhaseEnd

    rlPhaseStartTest "UnixBench 快速模式 (单线程核心测试)"
        if [ ! -f "$UNIXBENCH_DIR/UnixBench/Run" ]; then
            rlLogWarning "UnixBench 未安装，跳过测试"
            rlPhaseEnd
            rlJournalPrintText
            rlJournalEnd
            exit 0
        fi
        rlRun "./Run -i 3 -c 1 dhry2reg whetstone-double syscall pipe context1 spawn" 0 "UnixBench 快速模式 (3次迭代)"
        SCORE=$(grep -h "System Benchmarks Index Score" "$UNIXBENCH_DIR/UnixBench/results/"* 2>/dev/null | tail -1 | grep -oP '[\d.]+$' || echo "N/A")
        rlLogInfo "System Benchmarks Index Score: $SCORE"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd