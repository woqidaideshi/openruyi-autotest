#!/bin/sh -eux
# LTP POSIX 兼容性测试: pthread 多线程 - pthread_mutex_trylock 接口一致性

. "$(dirname "$0")/../../setup.sh"
. "$(dirname "$0")/../../helper.sh"

echo "=== LTP POSIX 兼容性测试: pthread / pthread_mutex_trylock ==="

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"
PASS=0; FAIL=0; SKIP=0

run_posix_iface_test "pthread_mutex_trylock" || true

echo ""
echo "=== pthread_mutex_trylock 结果: PASS=$PASS FAIL=$FAIL SKIP=$SKIP ==="
