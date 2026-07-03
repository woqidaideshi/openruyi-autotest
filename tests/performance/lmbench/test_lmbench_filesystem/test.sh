#!/bin/bash
# Performance: lmbench - 文件系统: 文件创建/删除, mmap, 页面错误延迟
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        lmbenchSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 ""
    rlPhaseEnd

    rlPhaseStartTest "文件创建/删除延迟"
        cd "$LMBENCH_DIR"
        echo "=== 文件操作延迟 (微秒) ==="

        # 0K 文件
        echo "0字节文件:"
        echo -n "  create: "; ./bin/lat_fs /tmp 2>&1 | grep -oP '[\d.]+' | head -1 || echo "N/A"
        echo -n "  delete: "; ./bin/lat_unlink /tmp 2>&1 | grep -oP '[\d.]+' | head -1 || echo "N/A"

        # 10K 文件  
        echo "10K文件:"
        ./bin/lat_fs 10k /tmp 2>&1 || true
        echo ""

        rlPass "文件操作延迟测试完成"
    rlPhaseEnd

    rlPhaseStartTest "mmap 映射延迟"
        cd "$LMBENCH_DIR"
        echo ""
        echo "=== mmap 延迟 (微秒) ==="
        for size in 1m 4m 16m; do
            echo -n "  mmap ${size}: "
            ./bin/lat_mmap ${size} /tmp 2>&1 | grep -oP '[\d.]+' | head -1 || echo "N/A"
        done
        rlPass "mmap 延迟分析完成"
    rlPhaseEnd

    rlPhaseStartTest "页面错误延迟"
        cd "$LMBENCH_DIR"
        echo ""
        echo "=== 页面错误处理延迟 ==="
        # Page fault (major/minor)
        echo -n "  minor page fault: "
        ./bin/lat_pagefault /tmp 2>&1 | grep -oP '[\d.]+' | head -1 || echo "N/A"

        # 文件系统带宽
        echo ""
        echo "=== 文件系统顺序读写带宽 ==="
        for size in 1m 4m; do
            echo -n "  read ${size}: "
            ./bin/bw_file_rd ${size} io_only /tmp 2>&1 | grep -oP '[\d.]+' | tail -1 || echo "N/A"
        done
        rlPass "页面错误分析完成"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
