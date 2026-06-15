#!/bin/sh
# CVE 安全测试套件 - 批量运行器
# 运行所有 test_cve-*.sh 并收集结果
# 每个测试超时 60 秒，防止卡死

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
RESULT_FILE="/tmp/cve_results.csv"
SUMMARY_FILE="/tmp/cve_summary.txt"
TEST_TIMEOUT=60

echo "=== CVE Security Test Suite Runner ==="
echo "Started at: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 结果文件头部
echo "cve_id,ltp_command,result,details" > "$RESULT_FILE"

PASS_COUNT=0
FAIL_COUNT=0
SKIP_COUNT=0
ERROR_COUNT=0
TOTAL=0

# 遍历所有 CVE 测试脚本
for script in "$SCRIPT_DIR"/test_cve-*.sh; do
    [ -f "$script" ] || continue
    TOTAL=$((TOTAL + 1))
    
    cve_name="$(basename "$script" .sh | sed 's/^test_//')"
    echo "[$TOTAL] Running: $cve_name ..."
    
    # 运行测试脚本，使用 timeout 防止卡死
    output=$(timeout $TEST_TIMEOUT bash "$script" 2>&1) || true
    
    # 解析结果
    if echo "$output" | grep -q "^PASS:"; then
        result="PASS"
        PASS_COUNT=$((PASS_COUNT + 1))
        detail=$(echo "$output" | grep "^PASS:" | head -1)
    elif echo "$output" | grep -q "^SKIP:"; then
        result="SKIP"
        SKIP_COUNT=$((SKIP_COUNT + 1))
        detail=$(echo "$output" | grep "^SKIP:" | head -1)
    elif echo "$output" | grep -q "^FAIL:"; then
        result="FAIL"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        detail=$(echo "$output" | grep "^FAIL:" | head -1)
    else
        # 检查是否有 LTP 测试返回了特定结果
        if echo "$output" | grep -qi "TPASS\|TFAIL\|TCONF\|TBROK\|TWARN"; then
            if echo "$output" | grep -q "TPASS"; then
                result="PASS"
                PASS_COUNT=$((PASS_COUNT + 1))
            elif echo "$output" | grep -q "TCONF"; then
                result="SKIP"
                SKIP_COUNT=$((SKIP_COUNT + 1))
            else
                result="FAIL"
                FAIL_COUNT=$((FAIL_COUNT + 1))
            fi
            detail=$(echo "$output" | grep -E "TPASS|TFAIL|TCONF|TBROK|TWARN" | head -1)
        else
            result="ERROR"
            ERROR_COUNT=$((ERROR_COUNT + 1))
            detail=$(echo "$output" | tail -3 | tr '\n' ' ')
        fi
    fi
    
    # 提取 LTP 命令名
    ltp_cmd=$(head -5 "$script" | grep "^# LTP Test:" | sed 's/^# LTP Test: *//' || echo "unknown")
    [ -z "$ltp_cmd" ] && ltp_cmd="unknown"
    
    echo "$cve_name,$ltp_cmd,$result,\"$detail\"" >> "$RESULT_FILE"
    echo "  => $result"
done

# 生成摘要
{
    echo "=== CVE Test Suite Summary ==="
    echo "Completed at: $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
    echo "Total:  $TOTAL"
    echo "PASS:   $PASS_COUNT"
    echo "FAIL:   $FAIL_COUNT"
    echo "SKIP:   $SKIP_COUNT"
    echo "ERROR:  $ERROR_COUNT"
    echo ""
    echo "Results saved to: $RESULT_FILE"
} | tee "$SUMMARY_FILE"

echo ""
echo "=== Done ==="
