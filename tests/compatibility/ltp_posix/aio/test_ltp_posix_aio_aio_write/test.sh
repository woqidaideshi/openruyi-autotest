#!/bin/sh -eux
# LTP POSIX 兼容性测试: 异步 I/O - aio_write 接口一致性

. "$(dirname "$0")/../../setup.sh"
. "$(dirname "$0")/../../helper.sh"

echo "=== LTP POSIX 兼容性测试: aio / aio_write ==="

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"
PASS=0; FAIL=0; SKIP=0

run_posix_iface_test "aio_write" || true

echo ""
echo "=== aio_write 结果: PASS=$PASS FAIL=$FAIL SKIP=$SKIP ==="
