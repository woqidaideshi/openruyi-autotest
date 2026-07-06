#!/bin/bash
# Performance: iozone - 多文件大小测试 (文档推荐: 1/2x, 1x, 2x 内存)
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        iozoneSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
        # 获取内存大小 (MB)
        TOTAL_MEM_MB=$(free -m | awk '/^Mem:/{print $2}')
        rlLogInfo "系统内存: ${TOTAL_MEM_MB} MB"
    rlPhaseEnd

    rlPhaseStartTest "多文件大小测试"
        local sizes="64 128 256 512"
        local throughputs=()

        for sz in $sizes; do
            local testfile="$TmpDir/iozone_${sz}m.dat"
            local log="$TmpDir/iozone_${sz}m.log"

            sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1 || true
            rlLogInfo "=== 测试文件大小: ${sz}M ==="

            iozone -c -s ${sz}m -r 16k -f "$testfile" 2>&1 | tee "$log"

            echo ""
            echo "--- IOzone ${sz}M 结果 ---"
            cat "$log"

            # 提取 write 吞吐量
            local write_kbps
            write_kbps=$(grep -E '^\s+[0-9]+\s+[0-9]+' "$log" | awk '{print $3}' | head -1)
            if [ -n "$write_kbps" ] && [ "$write_kbps" != "0" ]; then
                throughputs+=("${sz}M:${write_kbps}")
                rlLogInfo "${sz}M Write: ${write_kbps} KB/s"
            fi

            rm -f "$testfile"
        done

        # 汇总
        echo ""
        echo "=== 多尺寸测试汇总 ==="
        for t in "${throughputs[@]}"; do
            echo "  $t KB/s"
        done
        if [ ${#throughputs[@]} -gt 0 ]; then
            rlPass "多尺寸测试完成 (${#throughputs[@]}/4 个有效结果)"
        else
            rlFail "未能获取有效数据"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
