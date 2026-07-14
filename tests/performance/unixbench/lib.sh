# library-prefix = perf_unixbench

#

# Performance UnixBench suite-level shared library

# Uses flag-file + reference counting to ensure UnixBench

# is cloned and built only ONCE across all test cases.

#

# Builds UnixBench (v6.0.1) per Testing-Guide.md spec:

# - Clone v6.0.1 tag

# - git checkout -b br-v6.0.1

# - Patch maxCopies to `nproc`

# - Patch arch rv64g -> rva23u64 for riscv64

# - Compile with CC='gcc -std=gnu99'

#

# Key function: run_unixbench_3x()

# - Runs./Run 3 times independently (per Testing Guide requirement)

# - Saves each run's output to results/<test_name>/run_{1,2,3}.log

# - Extracts System Benchmarks Index Score from each run

# - Calculates average and writes results/<test_name>/summary.txt

#

# Usage in each test file:

#. "$(dirname "$0")/../lib.sh" # from test_unixbench_xxx/ subdirectories



UNIXBENCH_FLAG="/tmp/.beakerlib_unixbench_suite"

UNIXBENCH_DIR="/tmp/unixbench"

SUDO_PASSWORD="${TEST_SERVER_1_PASSWORD:-openruyi}"



unixbenchSetup() {

    if [ ! -f "$UNIXBENCH_FLAG" ]; then

    # Install build dependencies (per Testing-Guide.md spec)

    MISSING=""

    for dep in git gcc make perl gcc-c++ libtirpc-devel bc libtool automake; do

    if ! rpm -q "$dep" 2>/dev/null; then

    MISSING="$MISSING $dep"

    fi

    done

    if [ -n "$MISSING" ]; then

    echo "$SUDO_PASSWORD" | sudo -S dnf install -y $MISSING 2>/dev/null || true

    echo "installed_deps=1" > "$UNIXBENCH_FLAG"

    else

    echo "installed_deps=0" > "$UNIXBENCH_FLAG"

    fi



    # Clone and build UnixBench v6.0.1 (per Testing-Guide.md spec)

    if [ ! -f "$UNIXBENCH_DIR/Run" ]; then

    cd /tmp

    rm -rf unixbench byte-unixbench 2>/dev/null || true

    # Clone specific v6.0.1 tag (not just --depth 1)

    git clone -b v6.0.1 https://github.com/kdlucas/byte-unixbench.git 2>/dev/null && {

    mv byte-unixbench unixbench 2>/dev/null || true

    cd "$UNIXBENCH_DIR/UnixBench"

    # Create local branch per guide

    git checkout -b br-v6.0.1 2>/dev/null || true

    # Patch maxCopies to nproc for multi-threaded tests (>16 cores)

    sed -i "s/\('system.*'maxCopies'\) => 16/\1 => \`nproc\`/" Run

    # Patch arch for riscv64: rv64g -> rva23u64

    sed -i's/rv64g/rva23u64/g' Makefile

    # Compile with gnu99 standard

    make all CC='gcc -std=gnu99' -j$(nproc) 2>/dev/null || true

    echo "built=1" >> "$UNIXBENCH_FLAG"

    rlLogInfo "UnixBench v6.0.1 build complete"

    } || {

    echo "built=0" >> "$UNIXBENCH_FLAG"

    rlLogWarning "UnixBench clone/build failed"

    }

    else

    echo "built=0" >> "$UNIXBENCH_FLAG"

    rlLogInfo "UnixBench already present"

    fi

    echo "ref=1" >> "$UNIXBENCH_FLAG"

    else

    local ref

    ref=$(grep "^ref=" "$UNIXBENCH_FLAG" | cut -d= -f2)

    ref=$((ref + 1))

    sed -i "s/^ref=.*/ref=$ref/" "$UNIXBENCH_FLAG"

    rlLogInfo "UnixBench already initialized by another test, ref count: $ref"

    fi

    rlCleanupAppend "unixbenchCleanup"

}



unixbenchCleanup() {

    if [ ! -f "$UNIXBENCH_FLAG" ]; then

    return 0

    fi

    local ref

    ref=$(grep "^ref=" "$UNIXBENCH_FLAG" | cut -d= -f2)

    ref=$((ref - 1))

    if [ "$ref" -le 0 ]; then

    rm -rf "$UNIXBENCH_DIR" 2>/dev/null || true

    if grep -q "^installed_deps=1" "$UNIXBENCH_FLAG" 2>/dev/null; then

    echo "$SUDO_PASSWORD" | sudo -S dnf remove -y git gcc make perl gcc-c++ libtirpc-devel bc libtool automake 2>/dev/null || true

    fi

    rm -f "$UNIXBENCH_FLAG"

    rlLogInfo "UnixBench cleanup complete"

    else

    sed -i "s/^ref=.*/ref=$ref/" "$UNIXBENCH_FLAG"

    rlLogInfo "UnixBench kept ($ref tests remaining)"

    fi

}



# ============================================================

# run_unixbench_3x -- Run UnixBench 3 times and average scores

# ============================================================

#

# Per Testing-Guide.md: "testExecute three times, Average of all runs used as final score"

#

# Usage: run_unixbench_3x <test_name> [run_args...]

# test_name - Unique test identifier (e.g. "single_thread")

# run_args - Arguments passed to./Run (e.g. "-i 3 -c 1")

#

# Output files (under $UNIXBENCH_DIR/UnixBench/results/<test_name>/):

# run_1.log - Raw output of 1st run

# run_2.log - Raw output of 2nd run

# run_3.log - Raw output of 3rd run

# summary.txt - Structured summary with all scores and average

#

# Returns: average score on stdout (or "N/A" if extraction fails)

# ============================================================

run_unixbench_3x() {

    local test_name="$1"

    shift

    local run_args="$*"

    local result_dir="$UNIXBENCH_DIR/UnixBench/results/$test_name"

    # Also save to persistent location outside $UNIXBENCH_DIR (survives cleanup)

    local persist_dir="/tmp/unixbench_results_${test_name}"

    mkdir -p "$result_dir" "$persist_dir"



    # Clean up any prior results to avoid confusion with old.log files

    rm -f "$result_dir"/run_*.log "$result_dir"/summary.txt 2>/dev/null || true



    local scores=()

    local rcs=()

    for i in 1 2 3; do

    rlLogInfo "========== UnixBench [$test_name] # $i run =========="

./Run $run_args > "$result_dir/run_${i}.log" 2>&1

    local rc=$?

    rcs+=("$rc")

    rlLogInfo "# $i runComplete (exit code: $rc)"



    local score

    score=$(grep "System Benchmarks Index Score" "$result_dir/run_${i}.log" | tail -1 | awk '{print $NF}')

    if [ -z "$score" ]; then

    score="N/A"

    fi

    scores+=("$score")

    rlLogInfo "# $i System Benchmarks Index Score: $score"

    done



    # Calculate average if all 3 scores are numeric

    local avg="N/A"

    local s1="${scores[0]}"

    local s2="${scores[1]}"

    local s3="${scores[2]}"

    if [[ "$s1" =~ ^[0-9.]+$ ]] && [[ "$s2" =~ ^[0-9.]+$ ]] && [[ "$s3" =~ ^[0-9.]+$ ]]; then

    avg=$(awk "BEGIN {printf \"%.1f\", ($s1+$s2+$s3)/3}")

    fi



    # Generate structured summary file

    {

    echo "============================================="

    echo " UnixBench Test Results"

    echo "============================================="

    echo "Test: $test_name"

    echo "Date: $(date '+%Y-%m-%d %H:%M:%S')"

    echo "Host: $(hostname)"

    echo "CPU Cores: $(nproc)"

    echo "Command:./Run $run_args"

    echo "============================================="

    echo ""

    for i in 1 2 3; do

    echo "--- Run $i ---"

    echo "Exit Code: ${rcs[$((i-1))]}"

    echo "System Benchmarks Index Score: ${scores[$((i-1))]}"

    echo ""

    done

    echo "--- Summary ---"

    echo "Run 1 Score: ${scores[0]}"

    echo "Run 2 Score: ${scores[1]}"

    echo "Run 3 Score: ${scores[2]}"

    echo "Average: $avg"

    echo ""

    echo "--- Individual Sub-Test Scores (from Run 3) ---"

    # Extract the BASELINE/RESULT/INDEX table from run 3

    awk '/System Benchmarks Index Values/,/=======/' "$result_dir/run_3.log" 2>/dev/null || echo "(unavailable)"

    echo "============================================="

    } > "$result_dir/summary.txt"



    rlLogInfo "========== UnixBench [$test_name] result =========="

    rlLogInfo "Run 1: ${scores[0]} | Run 2: ${scores[1]} | Run 3: ${scores[2]}"

    rlLogInfo "Average System Benchmarks Index Score: $avg"

    rlLogInfo "Results saved to: $result_dir/"

    # Also copy to persistent location

    cp -r "$result_dir"/* "$persist_dir/" 2>/dev/null || true

    rlLogInfo "Persistent copy at: $persist_dir/"



    # Output average for caller

    echo "$avg"

}



# Extract System Benchmarks Index Score from UnixBench output file

# Usage: extract_score <log_file>

extract_score() {

    local log="$1"

    grep "System Benchmarks Index Score" "$log" | tail -1 | awk '{print $NF}'

}