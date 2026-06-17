#!/bin/sh -eux
# LTP POSIX 兼容性测试: 时钟 - clock_getres 接口一致性

. "$(dirname "$0")/../../setup.sh"
. "$(dirname "$0")/../../helper.sh"

echo "=== LTP POSIX 兼容性测试: clocks / clock_getres ==="

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"
PASS=0; FAIL=0; SKIP=0

run_posix_iface_test "clock_getres" || true

echo ""
echo "=== clock_getres 结果: PASS=$PASS FAIL=$FAIL SKIP=$SKIP ==="
