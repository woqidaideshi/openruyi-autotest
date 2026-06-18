#!/bin/sh -eux
# LTP POSIX 兼容性测试: 调度 - sched_getparam 接口一致性

. "$(dirname "$0")/../../setup.sh"
. "$(dirname "$0")/../../helper.sh"

echo "=== LTP POSIX 兼容性测试: sched / sched_getparam ==="

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"
PASS=0; FAIL=0; SKIP=0

run_posix_iface_test "sched_getparam" || true

echo ""
echo "=== sched_getparam 结果: PASS=$PASS FAIL=$FAIL SKIP=$SKIP ==="
