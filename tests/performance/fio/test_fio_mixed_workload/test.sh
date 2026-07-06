#!/bin/bash
# Performance: fio - 混合读写负载: 模拟数据库/应用场景的随机混合 IO
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        fioSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 ""
    rlPhaseEnd

    rlPhaseStartTest "数据库负载 (70R/30W, BS=8K)"
        local testfile="$TmpDir/db_workload.dat"
        local log="$TmpDir/db_randrw.log"

        rlLogInfo "=== 数据库混合负载: 70%读 30%写, BS=8K, 8jobs, iodepth=16 ==="
        _fioDropCaches
        fio --name=db_mixed --filename="$testfile" --direct=1 \
            --rw=randrw --rwmixread=70 --bs=8k --size=256M \
            --numjobs=8 --iodepth=16 --ioengine=libaio \
            --runtime=60 --thread --group_reporting 2>&1 | tee "$log"

        echo ""
        echo "=== 数据库负载结果 ==="
        cat "$log"
        _fioParseResult "$log"

        # 检查读写都有有效数据
        grep -q "read:" "$log" && rlPass "读数据有效"
        grep -q "write:" "$log" && rlPass "写数据有效"
        rm -f "$testfile"
    rlPhaseEnd

    rlPhaseStartTest "Web 服务器负载 (80R/20W, BS=4K)"
        local testfile="$TmpDir/web_workload.dat"
        local log="$TmpDir/web_randrw.log"

        rlLogInfo "=== Web 服务器负载: 80%读 20%写, BS=4K, 4jobs ==="
        _fioDropCaches
        fio --name=web_mixed --filename="$testfile" --direct=1 \
            --rw=randrw --rwmixread=80 --bs=4k --size=128M \
            --numjobs=4 --iodepth=32 --ioengine=libaio \
            --runtime=30 --thread --group_reporting 2>&1 | tee "$log"

        echo ""
        echo "=== Web 负载结果 ==="
        cat "$log"
        _fioParseResult "$log"
        rm -f "$testfile"
        rlPass "混合负载测试完成"
    rlPhaseEnd

    rlPhaseStartTest "读写比变化对比 (50/50, 70/30, 90/10)"
        echo ""
        echo "=== 读写比 vs 总吞吐 ==="
        printf "%-10s %-15s %-15s %-15s\n" "R/W比" "Read IOPS" "Write IOPS" "Total BW"

        for ratio in 50 70 90; do
            local testfile="$TmpDir/rw${ratio}.dat"
            local log="$TmpDir/rw${ratio}.log"
            _fioDropCaches
            fio --name=rw${ratio} --filename="$testfile" --direct=1 \
                --rw=randrw --rwmixread=$ratio --bs=8k --size=64M \
                --numjobs=4 --iodepth=16 --ioengine=libaio \
                --runtime=15 --thread --group_reporting 2>&1 | tee "$log"

            local riops wiop bw
            riops=$(grep "read:" "$log" | grep -oP 'IOPS=\K[\d.]+k?' | head -1)
            wiop=$(grep "write:" "$log" | grep -oP 'IOPS=\K[\d.]+k?' | head -1)
            bw=$(grep "READ:" "$log" | grep -oP 'bw=\K[\d.]+[KMG]iB/s' | head -1)
            printf "%-10s %-15s %-15s %-15s\n" "${ratio}/$((100-ratio))" "${riops:-N/A}" "${wiop:-N/A}" "${bw:-N/A}"
            rm -f "$testfile"
        done
        rlPass "读写比对比完成"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
