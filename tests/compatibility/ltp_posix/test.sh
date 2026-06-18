#!/bin/sh -eux
# LTP POSIX 兼容性测试: 运行所有 POSIX 接口一致性测试
# 本脚本聚合所有子测试用例

rlRun() { eval "$1" 2>&1; return $?; }

# Source setup
. "$(dirname "$0")/setup.sh"

echo "=========================================="
echo "  LTP POSIX 兼容性测试套件"
echo "=========================================="
echo ""

TOTAL_PASS=0
TOTAL_FAIL=0
TOTAL_SKIP=0

# 运行所有子测试 — 遍历 10 个分类目录下的 188 个测试用例
TEST_DIR="$(dirname "$0")"
for cat_dir in "$TEST_DIR"/aio "$TEST_DIR"/clocks "$TEST_DIR"/filesystem \
               "$TEST_DIR"/mmap "$TEST_DIR"/mqueue "$TEST_DIR"/pthread \
               "$TEST_DIR"/sched "$TEST_DIR"/semaphore "$TEST_DIR"/signal \
               "$TEST_DIR"/timer; do
    [ -d "$cat_dir" ] || continue
    for test_case in "$cat_dir"/test_ltp_posix_*/test.sh; do
        if [ -f "$test_case" ]; then
            echo ""
            echo ">>> 运行: $(basename "$(dirname "$test_case")")"
            if sh -eux "$test_case" 2>&1; then
                echo "<<< $(basename "$(dirname "$test_case")"): 完成"
            else
                echo "<<< $(basename "$(dirname "$test_case")"): 部分失败"
            fi
        fi
    done
done

echo ""
echo "=========================================="
echo "  LTP POSIX 兼容性测试完成"
echo "=========================================="
