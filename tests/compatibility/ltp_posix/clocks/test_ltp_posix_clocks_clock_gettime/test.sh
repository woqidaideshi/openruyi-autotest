#!/bin/sh -eux
# LTP POSIX 兼容性测试: 时钟 - clock_gettime 接口一致性

. "$(dirname "$0")/../../setup.sh"
. "$(dirname "$0")/../../helper.sh"

echo "=== LTP POSIX 兼容性测试: clocks / clock_gettime ==="

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"
PASS=0; FAIL=0; SKIP=0

run_posix_iface_test "clock_gettime" || true

echo ""
echo "=== clock_gettime 结果: PASS=$PASS FAIL=$FAIL SKIP=$SKIP ==="
