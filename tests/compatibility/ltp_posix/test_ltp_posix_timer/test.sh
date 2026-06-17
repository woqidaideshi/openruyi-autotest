#!/bin/sh -eux
# LTP POSIX 兼容性测试: timer 定时器接口一致性

. "$(dirname "$0")/../setup.sh"
. "$(dirname "$0")/../helper.sh"

echo "=== LTP POSIX 兼容性测试: timer 定时器接口 ==="

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"
PASS=0; FAIL=0; SKIP=0

INTERFACES="timer_create timer_delete timer_getoverrun timer_gettime timer_settime"

for iface in $INTERFACES; do
    run_posix_iface_test "$iface" || true
done

echo ""
echo "=== timer 结果: PASS=$PASS FAIL=$FAIL SKIP=$SKIP ==="
