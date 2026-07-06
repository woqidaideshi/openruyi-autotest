#!/bin/bash
# Performance: stream - 单核内存带宽: COPY/SCALE/ADD/TRIAD 四项操作
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        streamSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
        rlLogInfo "CPU 核心数: $(nproc)"
        lscpu 2>/dev/null | grep -i "cache\|model name" | head -10
    rlPhaseEnd

    rlPhaseStartTest "单核 COPY (1R+1W)"
        local log="/tmp/stream_copy.log"
        export OMP_NUM_THREADS=1
        _streamRun 1 > "$log" 2>&1
        rlRun "cat $log" 0 "STREAM COPY 完整输出"
        local bw
        bw=$(grep "^Copy:" "$log" | awk '{print $2}' | head -1)
        if [ -n "$bw" ] && [ "$bw" != "0" ]; then
            rlPass "COPY: ${bw} MB/s"
        else
            rlFail "COPY 未返回有效数据"
        fi
    rlPhaseEnd

    rlPhaseStartTest "单核 SCALE (1R+1W)"



        local log="/tmp/stream_scale.log"
        export OMP_NUM_THREADS=1
        _streamRun 1 > "$log" 2>&1
        rlRun "cat $log" 0 "STREAM SCALE 完整输出"
        local bw
        bw=$(grep "^Scale:" "$log" | awk '{print $2}' | head -1)
        [ -n "$bw" ] && [ "$bw" != "0" ] && rlPass "SCALE: ${bw} MB/s" || rlFail "SCALE 无数据"
    rlPhaseEnd

    rlPhaseStartTest "单核 ADD (2R+1W)"
        local log="/tmp/stream_add.log"
        export OMP_NUM_THREADS=1
        _streamRun 1 > "$log" 2>&1
        rlRun "cat $log" 0 "STREAM ADD 完整输出"
        local bw
        bw=$(grep "^Add:" "$log" | awk '{print $2}' | head -1)
        [ -n "$bw" ] && [ "$bw" != "0" ] && rlPass "ADD: ${bw} MB/s" || rlFail "ADD 无数据"
    rlPhaseEnd

    rlPhaseStartTest "单核 TRIAD (2R+1W, 最代表)"
        local log="/tmp/stream_triad.log"
        export OMP_NUM_THREADS=1
        _streamRun 1 > "$log" 2>&1
        echo ""
        echo "=== STREAM 单核完整结果 ==="
        cat "$log"
        _streamParseResult "$log"

        local bw
        bw=$(grep "^Triad:" "$log" | awk '{print $2}' | head -1)
        if [ -n "$bw" ] && [ "$bw" != "0" ]; then
            rlPass "单核 TRIAD: ${bw} MB/s (核心内存带宽)"
        else
            rlFail "TRIAD 未返回数据"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
        rm -f /tmp/stream_{copy,scale,add,triad}.log
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
