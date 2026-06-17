#!/bin/sh -eux
# LTP POSIX 兼容性测试: 调度 - sched_get_priority_min 接口一致性

. "$(dirname "$0")/../../setup.sh"
. "$(dirname "$0")/../../helper.sh"

echo "=== LTP POSIX 兼容性测试: sched / sched_get_priority_min ==="

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"
PASS=0; FAIL=0; SKIP=0

run_posix_iface_test "sched_get_priority_min" || true

echo ""
echo "=== sched_get_priority_min 结果: PASS=$PASS FAIL=$FAIL SKIP=$SKIP ==="
