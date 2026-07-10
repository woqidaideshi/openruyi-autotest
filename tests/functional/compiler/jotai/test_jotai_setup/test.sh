#!/bin/bash
# Functional test: compiler - jotai - 环境搭建与仓库准备
# 克隆 jotai-benchmarks 仓库，验证 benchmark 文件可用

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

BENCH_DIR="/tmp/jotai-benchmarks/benchmarks/anghaLeaves"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        jotaiSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
        rlRun "which git" 0 "git 命令可用"
    rlPhaseEnd

    rlPhaseStartTest "仓库验证"
        # 检查仓库目录是否存在
        if [ -d "/tmp/jotai-benchmarks" ]; then
            rlPass "jotai-benchmarks 目录存在"
            
            # 检查 benchmarks 子目录
            if [ -d "/tmp/jotai-benchmarks/benchmarks" ]; then
                rlPass "benchmarks 子目录存在"
                
                # 列出可用的 benchmark 文件
                rlRun "find /tmp/jotai-benchmarks/benchmarks -name '*.c' -type f | head -20" 0 "列出前 20 个 C benchmark 文件"
                
                # 验证有至少一个 C 文件
                count=$(find /tmp/jotai-benchmarks/benchmarks -name '*.c' -type f 2>/dev/null | wc -l)
                if [ "$count" -gt 0 ]; then
                    rlPass "仓库包含 $count 个 C benchmark 文件"
                else
                    rlFail "仓库不包含 C benchmark 文件"
                fi
                
                # 检查 anghaLeaves 目录
                if [ -d "$BENCH_DIR" ]; then
                    angha_count=$(find "$BENCH_DIR" -name '*.c' -type f 2>/dev/null | wc -l)
                    rlPass "anghaLeaves 目录包含 $angha_count 个 benchmark 文件"
                fi
            else
                rlFail "benchmarks 子目录不存在"
            fi
        else
            rlFail "jotai-benchmarks 克隆失败"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 "离开临时目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理临时目录"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
