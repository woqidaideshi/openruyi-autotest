# library-prefix = perf_fio
#
# fio (Flexible I/O Tester) suite-level shared library
# Measures OS storage I/O performance: throughput, IOPS, latency.
#
# Key parameters (from Testing-Guide):
#   - rw: read/write/randread/randwrite/randrw
#   - bs: block size (4k,16k,32k,64k,128k,256k,512k,1024k)
#   - direct=1: O_DIRECT, bypass page cache
#   - ioengine=libaio: Linux async I/O
#   - numjobs: concurrent job count
#   - iodepth: I/O queue depth per job
#   - runtime: test duration
#   - group_reporting: aggregate all jobs
#
# Results: BW (bandwidth), IOPS, latency (slat/clat/lat)
#   - Geometric mean across block sizes = overall score
#   - Run 3x, take average (per Testing-Guide)
#
# Usage: . "$(dirname "$0")/../lib.sh"

FIO_FLAG="/tmp/.beakerlib_fio_suite"

fioSetup() {
    if [ ! -f "$FIO_FLAG" ]; then
        if ! rpm -q fio 2>/dev/null; then
            echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf install -y fio 2>/dev/null
            echo "installed=1" > "$FIO_FLAG"
            rlLogInfo "已安装 fio"
        else
            echo "installed=0" > "$FIO_FLAG"
            rlLogInfo "fio 已存在"
        fi
        echo "ref=1" >> "$FIO_FLAG"
    else
        local ref
        ref=$(grep "^ref=" "$FIO_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$FIO_FLAG"
    fi
    rlCleanupAppend "fioCleanup"
}

fioCleanup() {
    if [ ! -f "$FIO_FLAG" ]; then return 0; fi
    local ref
    ref=$(grep "^ref=" "$FIO_FLAG" | cut -d= -f2)
    ref=$((ref - 1))
    if [ "$ref" -le 0 ]; then
        grep -q "^installed=1" "$FIO_FLAG" && echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf remove -y fio 2>/dev/null || true
        rm -f "$FIO_FLAG"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$FIO_FLAG"
    fi
}

# Parse fio output and extract key metrics
# Usage: _fioParseResult <logfile>
_fioParseResult() {
    local log="$1"
    if [ ! -f "$log" ]; then return 1; fi

    echo "--- fio 结果解析 ---"
    # Extract READ line
    grep "read:" "$log" | head -1
    # Extract WRITE line
    grep "write:" "$log" | head -1

    # Extract summary BW
    local rd_bw wr_bw
    rd_bw=$(grep "READ:" "$log" | grep -oP 'bw=\K[\d.]+[KMG]iB/s' | head -1)
    wr_bw=$(grep "WRITE:" "$log" | grep -oP 'bw=\K[\d.]+[KMG]iB/s' | head -1)

    if [ -n "$rd_bw" ]; then rlLogInfo "Read BW: $rd_bw"; fi
    if [ -n "$wr_bw" ]; then rlLogInfo "Write BW: $wr_bw"; fi

    # Extract IOPS
    local rd_iops wr_iops
    rd_iops=$(grep "read:" "$log" | grep -oP 'IOPS=\K[\d.]+k?' | head -1)
    wr_iops=$(grep "write:" "$log" | grep -oP 'IOPS=\K[\d.]+k?' | head -1)
    if [ -n "$rd_iops" ]; then rlLogInfo "Read IOPS: $rd_iops"; fi
    if [ -n "$wr_iops" ]; then rlLogInfo "Write IOPS: $wr_iops"; fi

    # Extract latency percentiles (p50, p99)
    grep "clat (" "$log" | grep -E "p50|p99" | head -2
    echo "--- 解析结束 ---"
}

# Clear page cache for fair testing
_fioDropCaches() {
    sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1 || true
    sleep 1
}
