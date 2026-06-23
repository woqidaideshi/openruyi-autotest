#!/bin/bash
# Performance test: UnixBench - UnixBench Shell脚本性能 (shell1 + shell8)
# 按照 Testing-Guide.md 要求：执行三次，取各次总分的平均值作为最终结果
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        unixbenchSetup
        rlRun "cd $UNIXBENCH_DIR/UnixBench" 0 "进入 UnixBench 目录"
    rlPhaseEnd

    rlPhaseStartTest "UnixBench Shell脚本性能 (shell1 + shell8, 3次独立运行)"
        if [ ! -f "$UNIXBENCH_DIR/UnixBench/Run" ]; then
            rlLogWarning "UnixBench 未安装，跳过测试"
            rlPhaseEnd
            rlJournalPrintText
            rlJournalEnd
            exit 0
        fi
        AVG=$(run_unixbench_3x "shell_scripts" "-i 3 -c 1 shell1 shell8")
        rlLogInfo "Shell脚本 3 次平均 System Benchmarks Index Score: $AVG"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd