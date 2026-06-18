#!/bin/sh -eux
# LTP POSIX 兼容性测试: pthread 多线程 - pthread_cond_timedwait 接口一致性

. "$(dirname "$0")/../../setup.sh"
. "$(dirname "$0")/../../helper.sh"

echo "=== LTP POSIX 兼容性测试: pthread / pthread_cond_timedwait ==="

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"
PASS=0; FAIL=0; SKIP=0

run_posix_iface_test "pthread_cond_timedwait" || true

echo ""
echo "=== pthread_cond_timedwait 结果: PASS=$PASS FAIL=$FAIL SKIP=$SKIP ==="
