# library-prefix = realtime
#
# Kernel Realtime suite-level shared library
# Reuses LTP installation from functional/ltp/lib.sh
# Uses flag-file + reference counting for suite-level setup/cleanup.
#
# Usage in each test file:
#   . "$(dirname "$0")/../lib.sh"    # from test_realtime_*/ subdirectories

# Reuse LTP setup/cleanup from functional/ltp suite
. "$(dirname "$0")/../../ltp/lib.sh"

REALTIME_FLAG="/tmp/.beakerlib_realtime_suite"

# Run a single LTP Realtime functional test via run.sh
# Pass / Fail / Skip are mapped to tmt result states.
# Usage: _realtimeRunCase <func_name>
_realtimeRunCase() {
    local func="$1"
    local out="/tmp/realtime_out_$$"

    if [ ! -x "$LTP_INSTALL_DIR/testcases/realtime/run.sh" ]; then
        rlFail "LTP Realtime runner not found ($LTP_INSTALL_DIR/testcases/realtime/run.sh)"
        return 1
    fi

    cd "$LTP_INSTALL_DIR" 2>/dev/null || true
    timeout --signal=KILL --kill-after=10 600 \
        ./testcases/realtime/run.sh -t "func/$func" 2>&1 | tee "$out"
    local rc=${PIPESTATUS[0]}

    if [ "$rc" -eq 137 ]; then
        rlFail "LTP Realtime $func 执行超时（被 kill）"
        rm -f "$out"
        return 1
    fi

    if [ "$rc" -ne 0 ]; then
        rlFail "LTP Realtime $func 执行失败 (exit=$rc)"
        rm -f "$out"
        return 1
    fi

    # Check for failure markers in output
    if grep -q "Result: FAIL" "$out"; then
        rlFail "LTP Realtime $func 测试失败 (Result: FAIL)"
        rm -f "$out"
        return 1
    fi

    # Check for success marker
    if grep -q "test appears to have completed" "$out"; then
        rlPass "LTP Realtime $func 测试通过"
        rm -f "$out"
        return 0
    fi

    # No explicit pass/fail marker — treat as pass if exit code is 0
    rlPass "LTP Realtime $func 测试完成 (exit=0)"
    rm -f "$out"
    return 0
}

realtimeSetup() {
    # Reuse LTP setup from functional/ltp suite
    ltpSetup

    if [ ! -f "$REALTIME_FLAG" ]; then
        echo "ref=1" > "$REALTIME_FLAG"
    else
        local ref
        ref=$(grep "^ref=" "$REALTIME_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$REALTIME_FLAG"
    fi

    rlCleanupAppend "realtimeCleanup"
}

realtimeCleanup() {
    if [ ! -f "$REALTIME_FLAG" ]; then return 0; fi
    local ref
    ref=$(grep "^ref=" "$REALTIME_FLAG" | cut -d= -f2)
    ref=$((ref - 1))
    if [ "$ref" -le 0 ]; then
        rm -f "$REALTIME_FLAG"
        rlLogInfo "Realtime 测试套清理完成"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$REALTIME_FLAG"
        rlLogInfo "Realtime 保留（还有 $ref 个测试未完成）"
    fi
}
