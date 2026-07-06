#!/bin/bash
# Performance: fio - 顺序读写吞吐量: 测量 OS 在大块数据连续传输时的带宽
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        fioSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
        _fioDropCaches
    rlPhaseEnd

    rlPhaseStartTest "顺序读吞吐量 (不同块大小)"
        local testfile="$TmpDir/seq_read.dat"
        # 预创建测试文件 (512MB)
        dd if=/dev/zero of="$testfile" bs=1M count=512 2>/dev/null

        for bs in 64 128 256 512 1024; do
            _fioDropCaches
            local log="$TmpDir/seq_read_${bs}k.log"
            rlLogInfo "=== 顺序读 BS=${bs}K ==="
            fio --name=seq_read_${bs}k --filename="$testfile" --direct=1 \
                --rw=read --bs=${bs}k --size=256M --numjobs=1 --iodepth=8 \
                --ioengine=libaio --runtime=30 --group_reporting 2>&1 | tee "$log"

            # 提取带宽
            local bw
            bw=$(grep "READ:" "$log" | grep -oP 'bw=\K[\d.]+[KMG]iB/s' | head -1)
            if [ -n "$bw" ]; then
                echo "  BS=${bs}K: BW=${bw}"
                rlPass "顺序读 BS=${bs}K: ${bw}"
            fi
        done
        rm -f "$testfile"
    rlPhaseEnd

    rlPhaseStartTest "顺序写吞吐量 (不同块大小)"
        _fioDropCaches
        for bs in 64 128 256 512 1024; do
            _fioDropCaches
            local log="$TmpDir/seq_write_${bs}k.log"
            rlLogInfo "=== 顺序写 BS=${bs}K ==="
            fio --name=seq_write_${bs}k --filename="$TmpDir/seq_write_${bs}k.dat" --direct=1 \
                --rw=write --bs=${bs}k --size=256M --numjobs=1 --iodepth=8 \
                --ioengine=libaio --runtime=30 --group_reporting 2>&1 | tee "$log"

            local bw
            bw=$(grep "WRITE:" "$log" | grep -oP 'bw=\K[\d.]+[KMG]iB/s' | head -1)
            if [ -n "$bw" ]; then
                echo "  BS=${bs}K: BW=${bw}"
                rlPass "顺序写 BS=${bs}K: ${bw}"
            fi
            rm -f "$TmpDir/seq_write_${bs}k.dat"
        done
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
