# library-prefix = perf_unixbench
#
# Performance UnixBench suite-level shared library
# Uses flag-file + reference counting to ensure UnixBench
# is cloned and built only ONCE across all test cases.
#
# Builds UnixBench v6.0.1 per Testing-Guide.md spec:
#   - Clone v6.0.1 tag
#   - Patch maxCopies to $(nproc)
#   - Patch arch rv64g -> rva23u64 for riscv64
#   - Compile with CC='gcc -std=gnu99'
#
# Usage in each test file:
#   . "$(dirname "$0")/../lib.sh"    # from test_unixbench_xxx/ subdirectories

UNIXBENCH_FLAG="/tmp/.beakerlib_unixbench_suite"
UNIXBENCH_DIR="/tmp/unixbench"
SUDO_PASSWORD="openruyi"

unixbenchSetup() {
    if [ ! -f "$UNIXBENCH_FLAG" ]; then
        # Install build dependencies
        MISSING=""
        for dep in git gcc make perl gcc-c++ libtirpc-devel; do
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

        # Clone and build UnixBench v6.0.1 (if not already present)
        if [ ! -f "$UNIXBENCH_DIR/Run" ]; then
            cd /tmp
            rm -rf unixbench
            git clone -b v6.0.1 https://github.com/kdlucas/byte-unixbench.git unixbench 2>/dev/null && {
                cd "$UNIXBENCH_DIR/UnixBench"
                # Patch maxCopies to $(nproc) for multi-threaded tests (>16 cores)
                sed -i "s/\('system.*'maxCopies'\) => 16/\1 => $(nproc)/" Run
                # Patch arch for riscv64: rv64g -> rva23u64
                sed -i 's/rv64g/rva23u64/g' Makefile
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
            echo "$SUDO_PASSWORD" | sudo -S dnf remove -y git gcc make perl gcc-c++ libtirpc-devel 2>/dev/null || true
        fi
        rm -f "$UNIXBENCH_FLAG"
        rlLogInfo "UnixBench cleanup complete"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$UNIXBENCH_FLAG"
        rlLogInfo "UnixBench kept ($ref tests remaining)"
    fi
}

# Extract System Benchmarks Index Score from UnixBench output
# Usage: extract_score <log_file>
extract_score() {
    local log="$1"
    grep "System Benchmarks Index Score" "$log" | tail -1 | awk '{print $NF}'
}