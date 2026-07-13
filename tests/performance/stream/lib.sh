# library-prefix = perf_stream
#
# STREAM memory bandwidth benchmark suite-level shared library
# Measures OS memory subsystem sustainable bandwidth.
#
# Four operations (per Testing-Guide):
#   COPY:  A[i] = B[i]               (1R + 1W)
#   SCALE: A[i] = scalar * B[i]      (1R + 1W)
#   ADD:   C[i] = A[i] + B[i]        (2R + 1W)
#   TRIAD: A[i] = B[i] + scalar * C[i] (2R + 1W)
#
# Key parameters:
#   -DSTREAM_ARRAY_SIZE=N: array size (>4x L3 cache)
#   -DNTIMES=N: iterations (default 10, best result kept)
#   -fopenmp: multi-threading
#   -O3: optimization
#
# Result: bandwidth in MB/s for each operation
#   Best result (MB/s) = maximum across iterations 2..NTIMES
#
# Usage: . "$(dirname "$0")/../lib.sh"

STREAM_FLAG="/tmp/.beakerlib_stream_suite"
STREAM_DIR="/tmp/stream_bench"

streamSetup() {
    if [ ! -f "$STREAM_FLAG" ]; then
        # Install build deps
        for dep in gcc wget; do
            if ! rpm -q "$dep" 2>/dev/null; then
                echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf install -y "$dep" 2>/dev/null
            fi
        done

        # Download and compile STREAM
        if [ ! -f "$STREAM_DIR/stream" ]; then
            mkdir -p "$STREAM_DIR"
            cd "$STREAM_DIR"
            wget -q https://raw.githubusercontent.com/jeffhammond/STREAM/refs/heads/master/stream.c 2>/dev/null || true
            if [ -f stream.c ]; then
                # Get L3 cache size to calculate array size
                local l3_kb
                l3_kb=$(lscpu 2>/dev/null | grep -i "L3 cache" | grep -oP '\d+' | head -1)
                if [ -z "$l3_kb" ] || [ "$l3_kb" -lt 1024 ]; then
                    l3_kb=4096  # default 4MB
                fi
                # Array size = 4x L3 cache / 8 bytes per element
                local array_elements=$(( l3_kb * 1024 / 8 * 4 ))
                # Ensure minimum 10M elements
                if [ "$array_elements" -lt 10000000 ]; then
                    array_elements=10000000
                fi
                rlLogInfo "L3 Cache: ${l3_kb}KB, Array elements: ${array_elements}"

                gcc -O3 -fopenmp -DSTREAM_ARRAY_SIZE=${array_elements} -DNTIMES=20 \
                    stream.c -o stream -lm 2>/dev/null
                if [ -x stream ]; then
                    echo "built=1" > "$STREAM_FLAG"
                    echo "array_size=$array_elements" >> "$STREAM_FLAG"
                    rlLogInfo "STREAM 编译成功 (array=$array_elements)"
                else
                    echo "built=0" > "$STREAM_FLAG"
                    rlLogWarning "STREAM 编译失败"
                fi
            else
                echo "built=0" > "$STREAM_FLAG"
                rlLogWarning "stream.c 下载失败"
            fi
            cd - >/dev/null
        else
            echo "built=0" > "$STREAM_FLAG"
            rlLogInfo "STREAM 已存在"
        fi
        echo "ref=1" >> "$STREAM_FLAG"
    else
        local ref
        ref=$(grep "^ref=" "$STREAM_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$STREAM_FLAG"
    fi
    rlCleanupAppend "streamCleanup"
}

streamCleanup() {
    if [ ! -f "$STREAM_FLAG" ]; then return 0; fi
    local ref
    ref=$(grep "^ref=" "$STREAM_FLAG" | cut -d= -f2)
    ref=$((ref - 1))
    if [ "$ref" -le 0 ]; then
        rm -f "$STREAM_FLAG"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$STREAM_FLAG"
    fi
}

# Run STREAM with given threads and parse output
# Usage: _streamRun <num_threads> [custom_affinity]
_streamRun() {
    local threads="${1:-1}"
    local affinity="${2:-0}"
    cd "$STREAM_DIR"
    if [ ! -x stream ]; then
        rlFail "STREAM 可执行文件不存在"
        return 1
    fi

    export OMP_NUM_THREADS=$threads
    if [ -n "$affinity" ]; then
        export GOMP_CPU_AFFINITY="$affinity"
    fi

    # Clear caches
    sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1 || true

    ./stream 2>&1
    return $?
}

# Parse STREAM output and display results table
_streamParseResult() {
    local log="$1"
    if [ ! -f "$log" ]; then return 1; fi

    echo ""
    echo "=== STREAM 内存带宽结果 ==="
    echo "Function    Best Rate MB/s  Avg time     Min time     Max time"
    grep -E "^(Copy|Scale|Add|Triad):" "$log" | head -4
    echo ""

    # Extract and validate
    local copy_bw scale_bw add_bw triad_bw
    copy_bw=$(grep "^Copy:" "$log" | awk '{print $2}' | head -1)
    scale_bw=$(grep "^Scale:" "$log" | awk '{print $2}' | head -1)
    add_bw=$(grep "^Add:" "$log" | awk '{print $2}' | head -1)
    triad_bw=$(grep "^Triad:" "$log" | awk '{print $2}' | head -1)

    if [ -n "$copy_bw" ] && [ -n "$triad_bw" ]; then
        rlLogInfo "Copy:  ${copy_bw} MB/s"
        rlLogInfo "Scale: ${scale_bw} MB/s"
        rlLogInfo "Add:   ${add_bw} MB/s"
        rlLogInfo "Triad: ${triad_bw} MB/s"
        echo "--- 解析结束 ---"
        return 0
    fi
    return 1
}
