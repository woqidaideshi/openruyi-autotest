#!/bin/sh -eux
# LTP POSIX 兼容性测试: pthread 多线程 - pthread_setschedprio 接口一致性

. "$(dirname "$0")/../../setup.sh"
. "$(dirname "$0")/../../helper.sh"

echo "=== LTP POSIX 兼容性测试: pthread / pthread_setschedprio ==="

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"
PASS=0; FAIL=0; SKIP=0

run_posix_iface_test "pthread_setschedprio" || true

echo ""
echo "=== pthread_setschedprio 结果: PASS=$PASS FAIL=$FAIL SKIP=$SKIP ==="
