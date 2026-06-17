#!/bin/sh -eux
# LTP POSIX 兼容性测试: clocks 时钟接口一致性

. "$(dirname "$0")/../setup.sh"
. "$(dirname "$0")/../helper.sh"

echo "=== LTP POSIX 兼容性测试: clocks 时钟接口 ==="

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"
PASS=0; FAIL=0; SKIP=0

INTERFACES="clock_getres clock_gettime clock_settime clock_nanosleep clock_getcpuclockid clock nanosleep"

for iface in $INTERFACES; do
    run_posix_iface_test "$iface" || true
done

echo ""
echo "=== clocks 结果: PASS=$PASS FAIL=$FAIL SKIP=$SKIP ==="
