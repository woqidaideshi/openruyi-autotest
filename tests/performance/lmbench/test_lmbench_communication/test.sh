#!/bin/bash
# Performance: lmbench - 通信: Pipe/TCP/UDP 本地通信延迟
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        lmbenchSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 ""
    rlPhaseEnd

    rlPhaseStartTest "本地通信延迟 (Pipe/Unix Socket/TCP/UDP)"
        cd "$LMBENCH_DIR"
        echo "=== 本地 IPC 延迟 (微秒) ==="

        # Pipe 延迟
        echo "Pipe:"
        ./bin/lat_pipe 2>&1 | head -3 || echo "  N/A"
        echo ""

        # Unix socket 延迟
        echo "Unix socket (AF_UNIX):"
        ./bin/lat_unix 2>&1 | head -3 || echo "  N/A"
        echo ""

        # TCP 本地延迟
        echo "TCP localhost:"
        ./bin/lat_tcp -s 2>&1 &
        local tcp_pid=$!
        sleep 1
        ./bin/lat_tcp localhost 2>&1 | head -5 || echo "  N/A"
        kill $tcp_pid 2>/dev/null || true
        echo ""

        # UDP 本地延迟
        echo "UDP localhost:"
        ./bin/lat_udp -s 2>&1 &
        local udp_pid=$!
        sleep 1
        ./bin/lat_udp localhost 2>&1 | head -5 || echo "  N/A"
        kill $udp_pid 2>/dev/null || true

        rlPass "本地通信延迟测试完成"
    rlPhaseEnd

    rlPhaseStartTest "完整 Benchmark 套件"
        cd "$LMBENCH_DIR"
        echo ""
        echo "=== LMbench 完整 Benchmark 运行 ==="

        # Run the full automated suite
        _lmbenchRun 2>&1 | tee /tmp/lmbench_full.log

        if [ -f "$LMBENCH_DIR/results/summary.out" ]; then
            cp "$LMBENCH_DIR/results/summary.out" /tmp/lmbench_summary.txt
            echo ""
            echo "=== 完整 Summary 输出 ==="
            cat /tmp/lmbench_summary.txt
            rlPass "完整 Benchmark 完成"
        else
            rlLogWarning "Summary 文件未生成"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
        rm -f /tmp/lmbench_{full,summary}.txt
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
