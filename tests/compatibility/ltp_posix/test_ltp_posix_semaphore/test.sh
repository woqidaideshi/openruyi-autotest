#!/bin/sh -eux
# LTP POSIX 兼容性测试: semaphore 信号量接口一致性

. "$(dirname "$0")/../setup.sh"
. "$(dirname "$0")/../helper.sh"

echo "=== LTP POSIX 兼容性测试: semaphore 信号量接口 ==="

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"
PASS=0; FAIL=0; SKIP=0

INTERFACES="sem_close sem_destroy sem_getvalue sem_init sem_open sem_post sem_timedwait sem_unlink sem_wait"

for iface in $INTERFACES; do
    run_posix_iface_test "$iface" || true
done

echo ""
echo "=== semaphore 结果: PASS=$PASS FAIL=$FAIL SKIP=$SKIP ==="
