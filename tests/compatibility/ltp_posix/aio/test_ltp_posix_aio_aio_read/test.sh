#!/bin/sh -eux
# LTP POSIX 兼容性测试: 异步 I/O - aio_read 接口一致性

. "$(dirname "$0")/../../setup.sh"
. "$(dirname "$0")/../../helper.sh"

echo "=== LTP POSIX 兼容性测试: aio / aio_read ==="

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"
PASS=0; FAIL=0; SKIP=0

run_posix_iface_test "aio_read" || true

echo ""
echo "=== aio_read 结果: PASS=$PASS FAIL=$FAIL SKIP=$SKIP ==="
