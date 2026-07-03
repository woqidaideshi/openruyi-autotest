#!/bin/bash
# Performance: lmbench - 处理器与内存延迟: CPU操作开销 + 内存访问延迟
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        lmbenchSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 ""
        if [ ! -f "$LMBENCH_DIR/bin/lmbench" ]; then
            rlFail "LMbench 未编译"; return 0
        fi
    rlPhaseEnd

    rlPhaseStartTest "处理器操作延迟 (null call, signal, fork)"
        cd "$LMBENCH_DIR"
        # 直接运行单个测试而非完整套件
        echo "=== null call 延迟 (系统调用开销) ==="
        ./bin/lat_syscall null 2>&1 || true
        echo ""

        echo "=== open/close 延迟 (文件系统调用) ==="
        ./bin/lat_syscall open /tmp 2>&1 || true
        echo ""

        echo "=== signal 处理延迟 ==="
        ./bin/lat_sig install 2>&1 || true
        echo ""

        echo "=== fork 延迟 (进程创建开销) ==="
        ./bin/lat_proc fork 2>&1 || true
        echo ""

        echo "=== exec 延迟 ==="
        ./bin/lat_proc exec 2>&1 || true
        echo ""

        echo "=== shell 延迟 ==="
        ./bin/lat_proc shell 2>&1 || true

        rlPass "处理器操作延迟测试完成"
    rlPhaseEnd

    rlPhaseStartTest "内存延迟分析"
        cd "$LMBENCH_DIR"

        # Memory latency with different sizes
        for size in 1M 4M 16M; do
            echo ""
            echo "=== 内存延迟 (${size}) ==="
            ./bin/lat_mem_rd ${size} 16 2>&1 | head -5
        done

        # Memory bandwidth
        echo ""
        echo "=== 内存带宽 (bw_mem) ==="
        for op in rd wr rdwr cp fwr frd fcp bzero bcopy; do
            local out
            out=$(./bin/bw_mem 16M "$op" 2>&1 | tail -1)
            if [ -n "$out" ]; then
                echo "  $op: $out MB/s"
            fi
        done

        rlPass "内存延迟分析完成"
    rlPhaseEnd

    rlPhaseStartTest "整型/浮点运算延迟"
        cd "$LMBENCH_DIR"
        echo ""
        echo "=== 基本运算延迟 (纳秒) ==="
        ./bin/lat_ops 2>&1 | head -20
        echo ""

        # Run lat_ops for specific types
        for op in bit add mul div mod; do
            echo -n "int $op: "
            ./bin/lat_ops -W 5 -N 3 "$op" 2>&1 | grep -oP '[\d.]+' | head -1
        done

        rlPass "运算延迟测试完成"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
