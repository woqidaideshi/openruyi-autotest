#!/bin/bash
# ============================================================
# 批量执行所有功能测试
# 遍历 tests/functional/ 下每个包目录
# 结果记录到 result_{pkg}.log
# ============================================================

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
FUNCTIONAL_DIR="$BASE_DIR/tests/functional"
RESULT_DIR="$BASE_DIR/test_results_$(date +%Y%m%d_%H%M%S)"
SUMMARY_FILE="$RESULT_DIR/summary.csv"
LOG_FILE="$RESULT_DIR/run_all.log"

mkdir -p "$RESULT_DIR"

echo "=== 功能测试批量执行 ===" | tee "$LOG_FILE"
echo "开始时间: $(date)" | tee -a "$LOG_FILE"
echo "结果目录: $RESULT_DIR" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# CSV 头
echo "package,status,details" > "$SUMMARY_FILE"

PASS_COUNT=0
FAIL_COUNT=0
SKIP_COUNT=0
ERROR_COUNT=0

# 遍历所有包目录
for pkg_dir in "$FUNCTIONAL_DIR"/*/; do
    pkg_name=$(basename "$pkg_dir")
    
    # 跳过非包目录
    if [ "$pkg_name" = "main.fmf" ] || [ "$pkg_name" = "README.md" ]; then
        continue
    fi
    
    # 检查是否有 test.sh
    test_script="$pkg_dir/test.sh"
    if [ ! -f "$test_script" ]; then
        echo "WARN: $pkg_name - no test.sh, skipping" | tee -a "$LOG_FILE"
        continue
    fi
    
    echo "" | tee -a "$LOG_FILE"
    echo "=== [$pkg_name] 开始测试 $(date +%H:%M:%S) ===" | tee -a "$LOG_FILE"
    
    result_file="$RESULT_DIR/result_${pkg_name}.log"
    
    # 执行测试（带超时 5 分钟）
    start_time=$(date +%s)
    timeout 300 bash "$test_script" > "$result_file" 2>&1
    exit_code=$?
    end_time=$(date +%s)
    elapsed=$((end_time - start_time))
    
    # 分析结果
    if [ $exit_code -eq 124 ]; then
        # timeout 退出码 124
        echo "  -> TIMEOUT (${elapsed}s)" | tee -a "$LOG_FILE"
        echo "$pkg_name,TIMEOUT,exceeded 300s limit" >> "$SUMMARY_FILE"
        ERROR_COUNT=$((ERROR_COUNT + 1))
    elif grep -q "SKIP:" "$result_file" 2>/dev/null; then
        skip_reason=$(grep "SKIP:" "$result_file" | head -1 | sed 's/.*SKIP: //')
        echo "  -> SKIP (${elapsed}s): $skip_reason" | tee -a "$LOG_FILE"
        echo "$pkg_name,SKIP,$skip_reason" >> "$SUMMARY_FILE"
        SKIP_COUNT=$((SKIP_COUNT + 1))
    elif grep -q "All.*functional tests passed" "$result_file" 2>/dev/null; then
        echo "  -> PASS (${elapsed}s)" | tee -a "$LOG_FILE"
        echo "$pkg_name,PASS," >> "$SUMMARY_FILE"
        PASS_COUNT=$((PASS_COUNT + 1))
    elif [ $exit_code -eq 0 ]; then
        echo "  -> PASS (${elapsed}s, exit 0)" | tee -a "$LOG_FILE"
        echo "$pkg_name,PASS,exit 0" >> "$SUMMARY_FILE"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        # 收集失败信息
        fail_detail=$(tail -20 "$result_file" | grep -E "FAIL|Error|error|cannot|not found|No such" | head -3 | tr '\n' '; ' | sed 's/;/; /g')
        if [ -z "$fail_detail" ]; then
            fail_detail="exit code $exit_code"
        fi
        echo "  -> FAIL (${elapsed}s, exit=$exit_code): $fail_detail" | tee -a "$LOG_FILE"
        echo "$pkg_name,FAIL,$fail_detail" >> "$SUMMARY_FILE"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    
done

echo "" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"
echo "  批量测试完成" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"
echo "  通过:   $PASS_COUNT" | tee -a "$LOG_FILE"
echo "  失败:   $FAIL_COUNT" | tee -a "$LOG_FILE"
echo "  跳过:   $SKIP_COUNT" | tee -a "$LOG_FILE"
echo "  异常:   $ERROR_COUNT" | tee -a "$LOG_FILE"
echo "  总计:   $((PASS_COUNT + FAIL_COUNT + SKIP_COUNT + ERROR_COUNT))" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"
echo "结束时间: $(date)" | tee -a "$LOG_FILE"
echo "详细结果: $RESULT_DIR/" | tee -a "$LOG_FILE"
echo "汇总报告: $SUMMARY_FILE" | tee -a "$LOG_FILE"
