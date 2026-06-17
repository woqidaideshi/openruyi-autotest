#!/bin/sh -eux
# LTP POSIX 兼容性测试: pthread 多线程 - pthread_key_create 接口一致性

. "$(dirname "$0")/../../setup.sh"
. "$(dirname "$0")/../../helper.sh"

echo "=== LTP POSIX 兼容性测试: pthread / pthread_key_create ==="

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"
PASS=0; FAIL=0; SKIP=0

run_posix_iface_test "pthread_key_create" || true

echo ""
echo "=== pthread_key_create 结果: PASS=$PASS FAIL=$FAIL SKIP=$SKIP ==="
