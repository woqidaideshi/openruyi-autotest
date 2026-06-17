#!/bin/sh -eux
# LTP POSIX 兼容性测试: 时钟 - clock_nanosleep 接口一致性

. "$(dirname "$0")/../../setup.sh"
. "$(dirname "$0")/../../helper.sh"

echo "=== LTP POSIX 兼容性测试: clocks / clock_nanosleep ==="

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"
PASS=0; FAIL=0; SKIP=0

run_posix_iface_test "clock_nanosleep" || true

echo ""
echo "=== clock_nanosleep 结果: PASS=$PASS FAIL=$FAIL SKIP=$SKIP ==="
