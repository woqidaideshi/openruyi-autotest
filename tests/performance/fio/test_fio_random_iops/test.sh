#!/bin/bash
# Performance: fio - 随机 I/O IOPS: 测量 OS 在随机访问模式下的 IOPS 能力
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        fioSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
    rlPhaseEnd

    rlPhaseStartTest "随机读 IOPS (不同块大小)"
        local testfile="$TmpDir/randread.dat"
        dd if=/dev/zero of="$testfile" bs=1M count=256 2>/dev/null

        for bs in 4 16 32 64; do
            _fioDropCaches
            local log="$TmpDir/randread_${bs}k.log"
            rlLogInfo "=== 随机读 BS=${bs}K ==="
            fio --name=randread_${bs}k --filename="$testfile" --direct=1 \
                --rw=randread --bs=${bs}k --size=128M --numjobs=4 --iodepth=16 \
                --ioengine=libaio --runtime=20 --thread --group_reporting 2>&1 | tee "$log"

            local iops bw
            iops=$(grep "read:" "$log" | grep -oP 'IOPS=\K[\d.]+k?' | head -1)
            bw=$(grep "READ:" "$log" | grep -oP 'bw=\K[\d.]+[KMG]iB/s' | head -1)
            echo "  BS=${bs}K: IOPS=${iops}, BW=${bw}"
            if [ -n "$iops" ]; then rlPass "随机读 BS=${bs}K: IOPS=${iops}"; fi
        done
        rm -f "$testfile"
    rlPhaseEnd

    rlPhaseStartTest "随机写 IOPS (不同块大小)"
        for bs in 4 16 32 64; do
            _fioDropCaches
            local log="$TmpDir/randwrite_${bs}k.log"
            rlLogInfo "=== 随机写 BS=${bs}K ==="
            fio --name=randwrite_${bs}k --filename="$TmpDir/randwrite_${bs}k.dat" --direct=1 \
                --rw=randwrite --bs=${bs}k --size=128M --numjobs=4 --iodepth=16 \
                --ioengine=libaio --runtime=20 --thread --group_reporting 2>&1 | tee "$log"

            local iops bw
            iops=$(grep "write:" "$log" | grep -oP 'IOPS=\K[\d.]+k?' | head -1)
            bw=$(grep "WRITE:" "$log" | grep -oP 'bw=\K[\d.]+[KMG]iB/s' | head -1)
            echo "  BS=${bs}K: IOPS=${iops}, BW=${bw}"
            if [ -n "$iops" ]; then rlPass "随机写 BS=${bs}K: IOPS=${iops}"; fi
            rm -f "$TmpDir/randwrite_${bs}k.dat"
        done
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
