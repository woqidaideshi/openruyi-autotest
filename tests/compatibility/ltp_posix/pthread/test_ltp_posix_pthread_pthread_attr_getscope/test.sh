#!/bin/sh -eux
# LTP POSIX 兼容性测试: pthread 多线程 - pthread_attr_getscope 接口一致性

. "$(dirname "$0")/../../setup.sh"
. "$(dirname "$0")/../../helper.sh"

echo "=== LTP POSIX 兼容性测试: pthread / pthread_attr_getscope ==="

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"
PASS=0; FAIL=0; SKIP=0

run_posix_iface_test "pthread_attr_getscope" || true

echo ""
echo "=== pthread_attr_getscope 结果: PASS=$PASS FAIL=$FAIL SKIP=$SKIP ==="
