# library-prefix = stress_ng
#
# stress-ng suite-level shared library
# System stress testing tool for reliability verification.
#
# Key metrics from stress-ng output:
#   - bogo ops/s (real time): throughput
#   - passed/failed/skipped counts
#   - usr/sys time ratio
#
# Result validation:
#   1. "successful run completed" in output → PASS
#   2. failed: 0 → PASS
#   3. Kernel tainted unchanged → PASS
#
# Usage: . "$(dirname "$0")/../lib.sh"

STRESS_FLAG="/tmp/.beakerlib_stress_ng_suite"

stressNgSetup() {
    if [ ! -f "$STRESS_FLAG" ]; then
        if ! rpm -q stress-ng 2>/dev/null; then
            echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf install -y stress-ng 2>/dev/null
            if ! rpm -q stress-ng 2>/dev/null; then
                rlLogWarning "stress-ng 安装失败"
                echo "installed=0" > "$STRESS_FLAG"
            else
                echo "installed=1" > "$STRESS_FLAG"
                rlLogInfo "已安装 stress-ng"
            fi
        else
            echo "installed=0" > "$STRESS_FLAG"
            rlLogInfo "stress-ng 已存在"
        fi
        echo "ref=1" >> "$STRESS_FLAG"
    else
        local ref
        ref=$(grep "^ref=" "$STRESS_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$STRESS_FLAG"
        rlLogInfo "stress-ng 引用计数: $ref"
    fi
    rlCleanupAppend "stressNgCleanup"
}

stressNgCleanup() {
    if [ ! -f "$STRESS_FLAG" ]; then return 0; fi
    local ref
    ref=$(grep "^ref=" "$STRESS_FLAG" | cut -d= -f2)
    ref=$((ref - 1))
    if [ "$ref" -le 0 ]; then
        if grep -q "^installed=1" "$STRESS_FLAG"; then
            echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf remove -y stress-ng 2>/dev/null || true
        fi
        rm -f "$STRESS_FLAG"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$STRESS_FLAG"
    fi
}

# Record tainted before test
_stressNgTaintBefore() {
    cat /proc/sys/kernel/tainted 2>/dev/null || echo "0"
}

# Check tainted after test
_stressNgTaintCheck() {
    local before="$1"
    local after
    after=$(cat /proc/sys/kernel/tainted 2>/dev/null || echo "0")
    if [ "$before" != "$after" ]; then
        rlFail "内核 tainted 变化: $before → $after"
    else
        rlPass "内核 tainted 无变化: $before"
    fi
}

# Validate stress-ng result from log file
# Checks: successful run completed, failed=0, bogo ops > 0
_stressNgValidate() {
    local log="$1"
    local stressor="$2"
    if [ ! -f "$log" ]; then rlFail "日志文件 $log 不存在"; return 1; fi

    # 1. "successful run completed"
    if grep -q "successful run completed" "$log"; then
        rlPass "$stressor: 成功完成"
    else
        rlFail "$stressor: 未正常完成"
    fi

    # 2. failed: 0
    local failed
    failed=$(grep -oP 'failed:\s*\K\d+' "$log" | tail -1)
    if [ -n "$failed" ] && [ "$failed" -eq 0 ]; then
        rlPass "$stressor: failed=$failed"
    elif [ -n "$failed" ]; then
        rlFail "$stressor: 存在 $failed 个失败"
    fi

    # 3. bogo ops/s > 0
    local bogo
    bogo=$(grep -oP "$stressor\s+.*?\s+(\d+\.?\d*)\s+\(\s*real\s+time\s*\)" "$log" | grep -oP '\d+\.?\d*(?=\s*\(\s*real)' | head -1)
    if [ -z "$bogo" ]; then
        bogo=$(grep "$stressor" "$log" | grep -oP '\d+\.?\d+(?=\s*\(\s*real)' | head -1)
    fi
    if [ -n "$bogo" ] && [ "$(echo "$bogo > 0" | bc 2>/dev/null || echo 1)" -eq 1 ]; then
        rlPass "$stressor: bogo ops/s = $bogo (real time)"
    else
        rlLogWarning "$stressor: 无法解析 bogo ops"
    fi
    return 0
}
