#!/bin/bash
# Performance: iozone - 顺序读写吞吐量基准
# 测量操作系统 IO 栈在纯顺序读写场景下的吞吐能力
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        iozoneSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
        sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1 || true
    rlPhaseEnd

    rlPhaseStartTest "顺序写吞吐量"
        local testfile="$TmpDir/seq_write.dat"
        local log="$TmpDir/seq_write.log"

        # 只用写操作 (-i 0)，固定记录大小，测试大文件顺序写
        iozone -c -s 256m -r 64k -i 0 -f "$testfile" 2>&1 | tee "$log"

        echo ""
        echo "=== 顺序写结果 (256M, 64K record) ==="
        cat "$log"

        local write_kbps
        write_kbps=$(grep -E '^\s+[0-9]+\s+[0-9]+' "$log" | awk '{print $3}' | head -1)
        if [ -n "$write_kbps" ] && [ "$write_kbps" != "0" ]; then
            local write_mbps
            write_mbps=$(awk "BEGIN {printf \"%.1f\", ${write_kbps}/1024}" 2>/dev/null)
            rlLogInfo "顺序写吞吐量: ${write_mbps} MB/s (${write_kbps} KB/s)"
            rlPass "顺序写: ${write_mbps} MB/s"
        else
            rlFail "未获取到顺序写数据"
        fi
        rm -f "$testfile"
    rlPhaseEnd

    rlPhaseStartTest "顺序读吞吐量"
        # 先写一个大文件，再测顺序读
        local testfile="$TmpDir/seq_read.dat"
        local log="$TmpDir/seq_read.log"

        # 预写文件
        dd if=/dev/zero of="$testfile" bs=1M count=256 2>/dev/null
        sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1 || true

        # 只用读操作 (-i 1)
        iozone -c -s 256m -r 64k -i 1 -f "$testfile" 2>&1 | tee "$log"

        echo ""
        echo "=== 顺序读结果 (256M, 64K record) ==="
        cat "$log"

        local read_kbps
        read_kbps=$(grep -E '^\s+[0-9]+\s+[0-9]+' "$log" | awk '{print $5}' | head -1)
        if [ -n "$read_kbps" ] && [ "$read_kbps" != "0" ]; then
            local read_mbps
            read_mbps=$(awk "BEGIN {printf \"%.1f\", ${read_kbps}/1024}" 2>/dev/null)
            rlLogInfo "顺序读吞吐量: ${read_mbps} MB/s (${read_kbps} KB/s)"
            rlPass "顺序读: ${read_mbps} MB/s"
        else
            rlFail "未获取到顺序读数据"
        fi
        rm -f "$testfile"
    rlPhaseEnd

    rlPhaseStartTest "读写比分析"
        # 同时测读写，观察读写吞吐比例
        local testfile="$TmpDir/rw_ratio.dat"
        local log="$TmpDir/rw_ratio.log"

        sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1 || true
        iozone -c -s 128m -r 64k -i 0 -i 1 -f "$testfile" 2>&1 | tee "$log"

        local w r
        w=$(grep -E '^\s+[0-9]+\s+[0-9]+' "$log" | awk '{print $3}' | head -1)
        r=$(grep -E '^\s+[0-9]+\s+[0-9]+' "$log" | awk '{print $5}' | head -1)

        if [ -n "$w" ] && [ -n "$r" ] && [ "$w" != "0" ]; then
            local ratio
            ratio=$(awk "BEGIN {printf \"%.2f\", ${r}/${w}}" 2>/dev/null)
            rlLogInfo "读/写吞吐比: ${ratio}x (读=${r} 写=${w} KB/s)"
        fi
        rlPass "读写比分析完成"
        rm -f "$testfile"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
