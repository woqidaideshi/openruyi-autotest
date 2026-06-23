#!/bin/bash
# Performance test: UnixBench - UnixBench 进程/上下文切换 (execl/pipe/context1/spawn)
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        unixbenchSetup
        rlRun "cd $UNIXBENCH_DIR/UnixBench" 0 "进入 UnixBench 目录"

    rlPhaseEnd

    rlPhaseStartTest "UnixBench 进程/上下文切换 (execl/pipe/context1/spawn)"
        if [ ! -f "$UNIXBENCH_DIR/UnixBench/Run" ]; then
            rlLogWarning "UnixBench 未安装，跳过测试"
            rlPhaseEnd
            rlJournalPrintText
            rlJournalEnd
            exit 0
        fi
        rlRun "./Run -i 3 -c 1 execl pipe context1 spawn" 0 "UnixBench 进程/上下文切换 (3次迭代)"
        SCORE=$(grep -h "System Benchmarks Index Score" "$UNIXBENCH_DIR/UnixBench/results/"* 2>/dev/null | tail -1 | grep -oP '[\d.]+$' || echo "N/A")
        rlLogInfo "System Benchmarks Index Score: $SCORE"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd