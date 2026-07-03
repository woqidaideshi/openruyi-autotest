#!/bin/bash
# Performance: sysbench - 文件 I/O: 顺序/随机 读写
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        sysbenchSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 ""
        local cores=$(nproc)
        local data_dir="$TmpDir/sb_fileio"
        mkdir -p "$data_dir"
    rlPhaseEnd

    rlPhaseStartTest "文件 I/O 全模式"
        echo ""
        echo "=== 文件 I/O 性能 (${cores} 线程, 直接 I/O) ==="
        printf "%-10s %-15s %-15s\n" "Mode" "MiB/s" "IOPS"

        for mode in seqwr seqrewr seqrd rndrd rndwr rndrw; do
            sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1 || true
            sleep 2

            local log="/tmp/sb_fileio_${mode}.log"

            # Prepare
            sysbench --threads=$cores --file-total-size=2G --file-test-mode=$mode \
                --file-num=4 fileio prepare 2>&1 > /dev/null

            # Run
            sysbench --threads=$cores --file-extra-flags=direct --file-total-size=2G \
                --file-test-mode=$mode --time=20 --report-interval=5 \
                fileio run 2>&1 | tee "$log"

            local bw iops
            bw=$(grep "MiB/sec" "$log" | grep -oP '[\d.]+' | head -1)
            iops=$(grep "reads/s\|writes/s" "$log" | grep -oP '[\d.]+' | head -1)
            printf "%-10s %-15s %-15s\n" "$mode" "${bw:-N/A}" "${iops:-N/A}"
            rlPass "fileio $mode: ${bw:-N/A} MiB/s"

            # Cleanup
            sysbench --threads=$cores --file-total-size=2G \
                --file-test-mode=$mode fileio cleanup 2>&1 > /dev/null
        done
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
        rm -f /tmp/sb_fileio_*.log
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
