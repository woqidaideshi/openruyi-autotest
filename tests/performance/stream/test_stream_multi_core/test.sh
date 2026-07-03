#!/bin/bash
# Performance: stream - 多核扩展性: 测量内存带宽随核心数增加的扩展能力
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        streamSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 ""
        local max_cores=$(nproc)
        rlLogInfo "CPU 核心数: $max_cores"
    rlPhaseEnd

    rlPhaseStartTest "多核 TRIAD 带宽扩展"
        echo ""
        echo "=== 多核内存带宽 (TRIAD) 扩展 ==="
        printf "%-8s %-15s %-15s %-15s\n" "Cores" "Triad(MB/s)" "Copy(MB/s)" "效率"
        local single_bw=""

        for t in 1 2 4 $(nproc); do
            # 跳过超过核心数的测试
            [ "$t" -gt "$max_cores" ] && continue

            local log="/tmp/stream_${t}core.log"
            rlLogInfo "=== ${t} 核心 TRIAD ==="
            export OMP_NUM_THREADS=$t
            _streamRun $t > "$log" 2>&1 2>/dev/null

            local triad copy
            triad=$(grep "^Triad:" "$log" | awk '{print $2}' | head -1)
            copy=$(grep "^Copy:" "$log" | awk '{print $2}' | head -1)

            if [ -n "$triad" ]; then
                if [ "$t" -eq 1 ]; then
                    single_bw="$triad"
                fi
                local eff="N/A"
                if [ -n "$single_bw" ] && [ "$single_bw" != "0" ]; then
                    eff=$(awk "BEGIN {printf \"%.1f%%\", ${triad}/${single_bw}/${t}*100}" 2>/dev/null || echo "N/A")
                fi
                printf "%-8s %-15s %-15s %-15s\n" "$t" "$triad" "${copy:-N/A}" "$eff"
                rlPass "${t}核 TRIAD: ${triad} MB/s"
            else
                rlFail "${t}核: 无数据"
            fi
        done

        if [ -n "$single_bw" ] && [ "$single_bw" != "0" ]; then
            rlLogInfo "基准 (单核 TRIAD): ${single_bw} MB/s"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
        rm -f /tmp/stream_*core.log
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
