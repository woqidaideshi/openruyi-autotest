#!/bin/sh -eux
# LTP POSIX 兼容性测试: 信号量 - sem_init 接口一致性

. "$(dirname "$0")/../../setup.sh"
. "$(dirname "$0")/../../helper.sh"

echo "=== LTP POSIX 兼容性测试: semaphore / sem_init ==="

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"
PASS=0; FAIL=0; SKIP=0

run_posix_iface_test "sem_init" || true

echo ""
echo "=== sem_init 结果: PASS=$PASS FAIL=$FAIL SKIP=$SKIP ==="
