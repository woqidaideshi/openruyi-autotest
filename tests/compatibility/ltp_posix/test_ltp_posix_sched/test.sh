#!/bin/sh -eux
# LTP POSIX 兼容性测试: sched 调度接口一致性

. "$(dirname "$0")/../setup.sh"
. "$(dirname "$0")/../helper.sh"

echo "=== LTP POSIX 兼容性测试: sched 调度接口 ==="

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"
PASS=0; FAIL=0; SKIP=0

INTERFACES="sched_get_priority_max sched_get_priority_min sched_getparam sched_getscheduler sched_rr_get_interval sched_setparam sched_setscheduler sched_yield"

for iface in $INTERFACES; do
    run_posix_iface_test "$iface" || true
done

echo ""
echo "=== sched 结果: PASS=$PASS FAIL=$FAIL SKIP=$SKIP ==="
