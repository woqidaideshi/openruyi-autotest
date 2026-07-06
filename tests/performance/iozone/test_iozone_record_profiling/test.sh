#!/bin/bash
# Performance: iozone - 输出解析: 分析各类 I/O 操作性能
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        iozoneSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
        sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1 || true
    rlPhaseEnd

    rlPhaseStartTest "全模式 I/O 测试"
        local testfile="$TmpDir/iozone_full.dat"
        local log="$TmpDir/iozone_full.log"

        # -i 0=write/rewrite, 1=read/reread, 2=random-read/write
        rlRun "iozone -c -s 128m -r 8k -i 0 -i 1 -i 2 -f $testfile 2>&1 | tee $log" 0 "全模式测试 (-i 0 -i 1 -i 2)"

        echo ""
        echo "=== IOzone 全模式输出 ==="
        cat "$log"
        echo "=== 输出结束 ==="
        echo ""

        # 解析各操作吞吐量
        _iozoneParseOutput "$log"
    rlPhaseEnd

    rlPhaseStartTest "不同记录大小对比"
        local rec_sizes="4 16 64 256 1024"
        echo ""
        echo "=== 记录大小 vs 吞吐量 ==="
        printf "%-10s %-15s %-15s\n" "记录(K)" "Write(KB/s)" "Read(KB/s)"

        for rs in $rec_sizes; do
            local testfile="$TmpDir/iozone_r${rs}k.dat"
            local log="$TmpDir/iozone_r${rs}k.log"

            sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1 || true
            iozone -c -s 64m -r ${rs}k -i 0 -i 1 -f "$testfile" 2>&1 | tee "$log"

            local w r
            w=$(grep -E '^\s+[0-9]+\s+[0-9]+' "$log" | awk '{print $3}' | head -1)
            r=$(grep -E '^\s+[0-9]+\s+[0-9]+' "$log" | awk '{print $5}' | head -1)
            printf "%-10s %-15s %-15s\n" "$rs" "${w:-N/A}" "${r:-N/A}"

            rm -f "$testfile"
        done

        rlPass "记录大小对比完成"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
