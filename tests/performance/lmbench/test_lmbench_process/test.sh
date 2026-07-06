#!/bin/bash
# Performance: lmbench - 进程: fork/exec 延迟, 上下文切换开销
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        lmbenchSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 ""
    rlPhaseEnd

    rlPhaseStartTest "进程创建生命周期"
        cd "$LMBENCH_DIR"
        echo "=== 进程创建开销 ==="
        echo "fork + exit 延迟 (微秒):"
        ./bin/lat_proc fork 2>&1
        echo ""

        echo "fork + execve 延迟 (微秒):"
        ./bin/lat_proc exec 2>&1
        echo ""

        echo "fork + /bin/sh 延迟 (微秒):"
        ./bin/lat_proc shell 2>&1

        rlPass "进程生命周期延迟测试完成"
    rlPhaseEnd

    rlPhaseStartTest "上下文切换开销"
        cd "$LMBENCH_DIR"
        echo ""
        echo "=== 上下文切换延迟 ==="

        # 不同进程数和数据大小的上下文切换
        for procs in 2 4 8 16; do
            for size in 0 16 64; do
                echo -n "  ${procs}p/${size}K: "
                ./bin/lat_ctx -s $size $procs 2>&1 | grep -oP '[\d.]+' | head -1
            done
        done

        rlPass "上下文切换分析完成"
    rlPhaseEnd

    rlPhaseStartTest "线程创建开销"
        cd "$LMBENCH_DIR"
        echo ""
        echo "=== 线程操作 ==="
        if [ -f bin/lat_pthread ]; then
            ./bin/lat_pthread create 2>&1 || echo "pthread 测试不可用"
        fi

        # 子进程与线程对比
        echo ""
        echo "=== fork vs thread 对比 ==="
        echo "fork: "
        ./bin/lat_proc fork 2>&1 | tail -1 || true
        rlPass "线程开销测试完成"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
