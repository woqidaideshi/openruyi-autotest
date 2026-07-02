#!/bin/bash
# Performance: iozone - Direct I/O 模式 (-I): 绕过 Page Cache 测试裸盘性能
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        iozoneSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
        sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1 || true
    rlPhaseEnd

    rlPhaseStartTest "Direct I/O vs Normal 对比"
        local testfile="$TmpDir/iozone_dio.dat"

        # Normal IO (使用 Page Cache)
        rlLogInfo "=== 标准 I/O (使用 Page Cache) ==="
        iozone -s 64m -r 4k -i 0 -i 1 -f "$testfile" 2>&1 | tee /tmp/iozone_normal.txt
        echo "--- 标准 I/O 结果 ---"
        cat /tmp/iozone_normal.txt

        sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1 || true
        rm -f "$testfile"

        # Direct IO (绕过 Page Cache)
        rlLogInfo "=== Direct I/O (绕过 Page Cache, -I) ==="
        iozone -I -s 64m -r 4k -i 0 -i 1 -f "$testfile" 2>&1 | tee /tmp/iozone_direct.txt
        echo "--- Direct I/O 结果 ---"
        cat /tmp/iozone_direct.txt

        # 验证两者都有输出
        grep -qE '^\s+[0-9]+\s+[0-9]+' /tmp/iozone_normal.txt && rlPass "标准 I/O: 数据行存在"
        grep -qE '^\s+[0-9]+\s+[0-9]+' /tmp/iozone_direct.txt && rlPass "Direct I/O: 数据行存在"

        # 对比分析
        local normal_write
        normal_write=$(grep -E '^\s+[0-9]+\s+[0-9]+' /tmp/iozone_normal.txt | awk '{print $3}' | head -1)
        local direct_write
        direct_write=$(grep -E '^\s+[0-9]+\s+[0-9]+' /tmp/iozone_direct.txt | awk '{print $3}' | head -1)

        rlLogInfo "标准 I/O Write: ${normal_write} KB/s"
        rlLogInfo "Direct I/O Write: ${direct_write} KB/s"

        if [ -n "$normal_write" ] && [ -n "$direct_write" ]; then
            # Direct I/O 通常更慢（绕过缓存）, 但不应该为 0
            if [ "$direct_write" != "0" ] && [ "$direct_write" != "" ]; then
                rlPass "Direct I/O 产生有效吞吐量: ${direct_write} KB/s"
            else
                rlLogWarning "Direct I/O 吞吐量为 0（可能 -I 不支持当前文件系统）"
            fi
            # 标准 I/O 应该比 Direct I/O 快（有缓存）
            rlLogInfo "缓存加速比: $(awk "BEGIN {printf \"%.1f\", ${normal_write}/${direct_write}}" 2>/dev/null || echo N/A)x"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
        rm -f /tmp/iozone_{normal,direct}.txt
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
